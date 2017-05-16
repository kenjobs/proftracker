import Vapor
import VaporPostgreSQL
import Fluent

var drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("posts", PostController())

drop.run()
