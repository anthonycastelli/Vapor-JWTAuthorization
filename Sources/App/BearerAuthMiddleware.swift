//
//  BearerAuthMiddleware.swift
//  JWTAuthentication
//
//  Created by Anthony Castelli on 11/12/16.
//
//

import Vapor
import HTTP
import Turnstile
import Auth
import VaporJWT

class BearerAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        // Authorization: Bearer Token
        if let bearer = request.auth.header?.bearer {
            // Verify the token
            do {
                let receivedJWT = try JWT(token: bearer.string)
                if try receivedJWT.verifySignatureWith(HS256(key: Authentication.AccessTokenSigningKey)) {
                    
                    // Valide it's time stamp
                    if receivedJWT.verifyClaims([ExpirationTimeClaim()]) {
                        try? request.auth.login(bearer, persist: false)
                    } else {
                        throw Abort.custom(status: .unauthorized, message: "Please reauthenticate with the server.")
                    }
                } else {
                    throw Abort.custom(status: .unauthorized, message: "Please reauthenticate with the server.")
                }
            } catch {
                throw Abort.custom(status: .unauthorized, message: "Please reauthenticate with the server.")
            }
        }
        
        return try next.respond(to: request)
    }
}
