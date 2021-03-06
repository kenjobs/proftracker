import Vapor
import VaporPostgreSQL
import Fluent

var drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Professor.self
drop.preparations += Schedule.self

let profcontroller = ProfessorsController()
profcontroller.addRoutes(drop: drop)


drop.run()
