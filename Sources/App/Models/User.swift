//
//  User.swift
//  JWTAuthentication
//
//  Created by Anthony Castelli on 5/31/17.
//  Copyright © 2017 Anthony Castelli. All rights reserved.
//

import Vapor
import FluentProvider
import AuthProvider
import JWT
import HTTP

public enum RegistrationError: Error {
    case emailTaken
}

extension RegistrationError: Debuggable {
    public var reason: String {
        let reason: String
        
        switch self {
        case .emailTaken: reason = "Email is already taken"
        }
        
        return "Authentication error: \(reason)"
    }
    
    public var identifier: String {
        switch self {
        case .emailTaken: return "emailtaken"
        }
    }
    
    public var suggestedFixes: [String] {
        return []
    }
    
    public var possibleCauses: [String] {
        return []
    }
}

final class User: Model {
    let storage = Storage()
    
    var username: String
    var password: Bytes

    /// Creates a new Post
    init(username: String, password: Bytes) {
        self.username = username
        self.password = password
    }

    // MARK: Fluent Serialization
    
    init(row: Row) throws {
        username = try row.get("username")
        password = try row.get("password")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("username", username)
        try row.set("password", password)
        return row
    }
}

// MARK: Fluent Preparation

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("username")
            builder.string("password")
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: SessionPersistable { }

extension User: PasswordAuthenticatable {
    
    static func register(username: String, password: Bytes) throws -> User {
        guard try User.makeQuery().filter("username", username).first() == nil else { throw RegistrationError.emailTaken }
        let user = User(username: username, password: password)
        try user.save()
        return user
    }
    
    var hashedPassword: String? {
        return self.password.makeString()
    }
    
    static var usernameKey: String {
        return "username"
    }
    
    static var passwordKey: String {
        return "password"
    }
    
    static var passwordHasher: BCryptHasher {
        return BCryptHasher(cost: 10)
    }
    
    static var passwordVerifier: PasswordVerifier? {
        return User.passwordHasher
    }
    
    func updatePassword(_ password: String) throws {
        self.password = try User.passwordHasher.make(password)
    }
}

extension User: TokenAuthenticatable {
    
    public typealias TokenType = User
    
    static func authenticate(_ token: Token) throws -> User {
        let jwt = try JWT(token: token.string)
        try jwt.verifySignature(using: HS256(key: "SIGNING_KEY".makeBytes()))
        let time = ExpirationTimeClaim(date: Date())
        try jwt.verifyClaims([time])
        guard let userId = jwt.payload.object?[SubjectClaim.name]?.string else { throw AuthenticationError.invalidCredentials }
        guard let user = try User.makeQuery().filter("id", userId).first() else { throw AuthenticationError.invalidCredentials }
        return user
    }
}

// MARK: JSON

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            username: json.get("username"),
            password: json.get("password")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("username", username)
        try json.set("password", password)
        return json
    }
}

// MARK: HTTP

extension User: ResponseRepresentable { }

extension Request {
    func user() throws -> User {
        return try auth.assertAuthenticated()
    }
}
