//
//  User.swift
//  JWTAuthentication
//
//  Created by Anthony Castelli on 5/31/17.
//  Copyright © 2017 Anthony Castelli. All rights reserved.
//

import Vapor
import FluentProvider
import HTTP

final class User: Model {
    let storage = Storage()
    
    var username: String
    var password: String

    /// Creates a new Post
    init(username: String, password: String) {
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
