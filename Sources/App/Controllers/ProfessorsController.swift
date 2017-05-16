import Vapor
import HTTP

final class ProfessorsController {
    
    func addRoutes(drop: Droplet){
        let basic = drop.grouped("professors")
        basic.post(handler: create)
        basic.get(handler: index)
        basic.delete(Professor.self, handler: delete)
        basic.get(Professor.self, handler: showProfessor)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Professor.all().makeNode())
    }
    
    
    func showProfessor(request: Request, professor: Professor) throws -> ResponseRepresentable {
        return professor
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        
        print("CALLING IN!")
        var professor = try request.professor()
        try professor.save()
        return professor
    }
    
    func show(request: Request, professor: Professor) throws -> ResponseRepresentable {
        return professor
    }
    
    func update(request: Request, professor: Professor) throws -> ResponseRepresentable {
        let new = try request.professor()
        var professor = professor
        professor.firstName = new.firstName
        professor.lastName = new.lastName
        professor.middleName = new.middleName
        professor.department = new.department
        professor.profilePictureUrl = new.profilePictureUrl
        
        try professor.save()
        
        return professor
    }
    
    func delete(request: Request, professor: Professor) throws -> ResponseRepresentable {
        try professor.delete()
        
        return JSON([:])
    }
    
    func addProfessor(request: Request) throws -> ResponseRepresentable {
        
        print("Calling in")
        guard let firstName = request.data["firstName"]?.string, let lastName = request.data["lastName"]?.string, let middleName = request.data["middleName"]?.string, let department = request.data["department"]?.string, let profilePictureUrl = request.data["profilePictureUrl"]?.string else {
            
            print("Bad request")
            throw Abort.badRequest
        }
        
        var professor = Professor(firstName: firstName, middleName: middleName, lastName: lastName, department: department, profilePictureUrl: profilePictureUrl)
        
        try professor.save()
        
        return professor
    }
}

extension Request {
    func professor() throws -> Professor {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try Professor(node: json)
    }
}