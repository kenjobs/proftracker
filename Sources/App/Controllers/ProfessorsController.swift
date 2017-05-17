import Vapor
import HTTP

final class ProfessorsController {
    
    func addRoutes(drop: Droplet){
        let basic = drop.grouped("professors")
        basic.post(handler: addProfessor)
        basic.get(handler: index)
        basic.delete(Professor.self, handler: delete)
        basic.get(Professor.self, handler: show)
        
        basic.get(handler: showProfessorWithSchedules)
        // SCHEDULES RELATED
        basic.post("createSchedule", handler: createSchedule)
        basic.post("updateSchedule", Schedule.self, handler: updateScheduleStatus)
        basic.get(Professor.self, "schedules", handler: showSchedules)
    }
    
    func showProfessorWithSchedules(request: Request) throws -> ResponseRepresentable {
        Professor.includeSchedules = true
        
        let payload = ["Professors": try Professor.all().makeNode()]
        
        return try JSON(node: payload)
    }
    
    func updateScheduleStatus(request: Request, schedule: Schedule) throws -> ResponseRepresentable {
        guard let attending = request.data["attending"]?.bool else {
            throw Abort.badRequest
        }
    
        var schedule = schedule
        schedule.status = ((attending) ? "ATTENDING" : "NOT ATTENDING")
        try schedule.save()
        
        return schedule
    }

    
    func createSchedule(request: Request) throws -> ResponseRepresentable {
        var schedule = try request.schedule()
        try schedule.save()
        
        return schedule
    }
    
    func showSchedules(request: Request, professor: Professor) throws -> ResponseRepresentable {
        let schedules = try professor.schedules()
        
        return try JSON(node: schedules.makeNode())
    }

    func addProfessor(request: Request) throws -> ResponseRepresentable {
        Professor.includeSchedules = false
        guard let firstName = request.data["firstname"]?.string, let lastName = request.data["lastname"]?.string, let middleName = request.data["middlename"]?.string, let department = request.data["department"]?.string, let profilePictureUrl = request.data["profile_picture_url"]?.string else {
            throw Abort.badRequest
        }
        
        var professor = Professor(firstName: firstName, middleName: middleName, lastName: lastName, department: department, profilePictureUrl: profilePictureUrl)
        
        try professor.save()
        
        return professor
    }
    
    // BASIC METHODS FOR PROFESSORS
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Professor.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
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
}

extension Request {
    func professor() throws -> Professor {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try Professor(node: json)
    }
    
    func schedule() throws -> Schedule {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try Schedule(node: json)
    }
}
