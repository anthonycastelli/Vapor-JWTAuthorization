import Vapor
import HTTP
import AuthProvider
import JWTProvider

final class GeneralRoutes: RouteCollection {
    var droplet: Droplet
    init(_ droplet: Droplet) {
        self.droplet = droplet
    }
    func build(_ builder: RouteBuilder) throws {
        let api = builder.grouped("api")
        let v1 = api.grouped("v1")
        
        let userController = UserController(self.droplet)
        v1.post("register", handler: userController.register)
        v1.post("login", handler: userController.login)
        v1.post("logout", handler: userController.logout)
        
        //NOTE: TokenAuthenticationMiddleware should be used only to fluent token auth, not JWT
        //let secured = v1.grouped(TokenAuthenticationMiddleware(User.self))
        let tokenMiddleware = PayloadAuthenticationMiddleware(self.droplet.signer!,[], User.self)
        let secured = v1.grouped(tokenMiddleware)
        let users = secured.grouped("users")
        users.get("me", handler: userController.me)
    }
}
