//
//  User.swift
//  JWTAuthentication
//
//  Created by Anthony Castelli on 11/12/16.
//
//

import Vapor
import Fluent
import Foundation
import Turnstile
import TurnstileCrypto
import Auth
import JWT
import Core

struct Authentication {
    static let AccessTokenSigningKey = "CHANGE_ME"
    static let Length = 60 * 5 // 5 Minutes later
}

final class User: Auth.User {

    var id: Node?
    var username: String!
    var password: String!

    init(username: String, password: String) {
        self.username = username
        self.password = BCrypt.hash(password: password)
    }

    init(node: Node, in context: Context) throws {
        self.id = node["id"]
        self.username = try node.extract("username")
        self.password = try node.extract("password")
    }

    init(credentials: UsernamePassword) {
        self.username = credentials.username
        self.password = BCrypt.hash(password: credentials.password)
    } 
}

// MARK: Authentication
extension User {
    @discardableResult
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        var user: User?

        switch credentials {
        case let credentials as UsernamePassword:
            let fetchedUser = try User.query().filter("username", credentials.username).first()
            if let password = fetchedUser?.password, password != "", (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
                user = fetchedUser
            }

        case let credentials as Auth.AccessToken:
            // Verify the token
            let receivedJWT = try JWT(token: credentials.string)

            // Verify the token
            try receivedJWT.verifySignature(using: HS256(key: Authentication.AccessTokenSigningKey.makeBytes()))
            if receivedJWT.verifyClaims([ExpirationTimeClaim(Seconds(Authentication.Length))]) { //ExpirationTimeClaim(Authentication.AccesTokenValidationLength)
                guard let userId = receivedJWT.payload.object?[SubjectClaim.name]?.string else { throw IncorrectCredentialsError() }
                user = try User.query().filter("id", userId).first()
            } else {
                throw IncorrectCredentialsError()
            }

        default: throw UnsupportedCredentialsError()
        }

        guard let guardedUser = user else { throw IncorrectCredentialsError() }
        return guardedUser
    }

    @discardableResult
    static func register(credentials: Credentials) throws -> Auth.User {
        var newUser: User

        switch credentials {
        case let credentials as UsernamePassword:
            newUser = User(credentials: credentials)

        default: throw UnsupportedCredentialsError()
        }

        if try User.query().filter("username", newUser.username).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
        }

    }

}

// MARK: Node Representable
extension User: NodeRepresentable {
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id,
            "username": self.username,
            "password": self.password
        ])
    }

}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }

    static func revert(_ database: Database) throws {
        //
    }
}
