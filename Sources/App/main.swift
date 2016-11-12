import Vapor
import Fluent
import Auth

let drop = Droplet()

drop.database = Database(MemoryDriver())
drop.preparations.append(User.self)

drop.middleware.append(AuthMiddleware<User>())

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.group("api") { api in
    api.group("v1") { v1 in
        
        let usersController = UsersController()
        
        /*
         * Registration
         * Create a new Username and Password to receive an authorization token and account
         */
        v1.post("register", handler: usersController.register)
        
        /*
         * Log In
         * Pass the Username and Password to receive a new token
         */
        v1.post("login", handler: usersController.login)
        
        /*
         * Log out
         */
        v1.post("logout", handler: usersController.logout)
        
        /*
         * Secured Endpoints
         * Anything in here requires the Authorication header:
         * Example: "Authorization: Bearer TOKEN"
         */
        let protect = ProtectMiddleware(error: Abort.custom(status: .unauthorized, message: "Unauthorized"))
        v1.group(BearerAuthMiddleware(), protect) { secured in
            
            let users = secured.grouped("users")
            /*
             * Validation: I use this to check on the token periodically to see
             * if I need a new token while the user is using the app.
             */
            users.post("validate", handler: usersController.validateAccessToken)
            
            /*
             * Me
             * Get the current users info
             */
            users.get("me", handler: usersController.me)
        }
    }
}

drop.run()
