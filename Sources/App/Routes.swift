import Vapor
import HTTP
import AuthProvider

final class GenealRoutes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        let api = builder.grouped("api")
        let v1 = api.grouped("v1")
        
        let userController = UserController()
        v1.post("register", handler: userController.register)
        v1.post("login", handler: userController.login)
        v1.post("logout", handler: userController.logout)
        
        let secured = v1.grouped(TokenAuthenticationMiddleware(User.self))
        let users = secured.grouped("users")
        users.get("me", handler: userController.me)
    }
}

extension GenealRoutes: EmptyInitializable { }
