//
//  UsersController.swift
//  JWTAuthentication
//
//  Created by Anthony Castelli on 11/12/16.
//
//


import Foundation
import Vapor
import HTTP
import Turnstile
import TurnstileCrypto
import TurnstileWeb

final class UsersController {
    
    // MARK: Authentication
    
    func register(request: Request) throws -> ResponseRepresentable {
        // Get our credentials
        guard let username = request.data["username"]?.string, let password = request.data["password"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Missing username or password")
        }
        let credentials = UsernamePassword(username: username, password: password)
        
        
        // Try to register the user
        do {
            try _ = User.register(credentials: credentials)
            try request.auth.login(credentials)
            
            return try JSON(node: ["success": true, "user": request.user().makeNode()])
        } catch let e as TurnstileError {
            throw Abort.custom(status: Status.badRequest, message: e.description)
        }
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        // Get our credentials
        guard let username = request.data["username"]?.string, let password = request.data["password"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Missing username or password")
        }
        let credentials = UsernamePassword(username: username, password: password)
        
        do {
            try request.auth.login(credentials)
            return try JSON(node: ["success": true, "user": request.user().makeNode()])
        } catch _ {
            throw Abort.custom(status: Status.badRequest, message: "Invalid email or password")
        }
    }
    
    func logout(request: Request) throws -> ResponseRepresentable {
        // Invalidate the current access token
        var user = try request.user()
        user.token = nil
        try user.save()
        
        // Clear the session
        request.subject.logout()
        return try JSON(node: ["success": true])
    }
    
    func validateAccessToken(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        guard let _ = user.token else {
            throw Abort.badRequest
        }
        
        // Check if the token is expired, or invalid and generate a new one
        if try user.validateToken() {
            try user.save()
        }
        
        return try JSON(node: ["success": true])
    }
    
    // MARK: Custom Endpoints
    
    func me(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: request.user().makeNode())
    }
    
}

extension Request {
    // Helper method to get the current user
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw UnsupportedCredentialsError()
        }
        return user
    }
    
    // Base URL returns the hostname, scheme, and port in a URL string form.
    var baseURL: String {
        return uri.scheme + "://" + uri.host + (uri.port == nil ? "" : ":\(uri.port!)")
    }
    
    // Exposes the Turnstile subject, as Vapor has a facade on it.
    var subject: Subject {
        return storage["subject"] as! Subject
    }
}
