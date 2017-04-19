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
import JWT

class BearerAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {

        // Authorization: Bearer Token
        if let bearer = request.auth.header?.bearer {
            // Verify the token
            let receivedJWT = try JWT(token: bearer.string)

            // Verify the signature
            try receivedJWT.verifySignature(using: HS256(key: Authentication.AccessTokenSigningKey.makeBytes()))

            // Valide it's time stamp
            if receivedJWT.verifyClaims([ExpirationTimeClaim(Seconds(Authentication.Length))]) { //ExpirationTimeClaim(Authentication.AccesTokenValidationLength)
                try request.auth.login(bearer)
            } else {
                throw Abort.custom(status: .unauthorized, message: "Please reauthenticate with the server.")
            }
        }

        return try next.respond(to: request)
    }
}
