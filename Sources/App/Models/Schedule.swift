import Vapor

final class Schedule: Model{
    var id: Node?
    var exists: Bool = false
    var uuid: String
    var room: String
    var status: String
    var startTime: String
    var endTime: String
    var day: String
    var section: String
    var subject: String
    var professorId: Node?
    
    init(uuid: String, room: String, status: String, startTime: String, endTime: String, day: String, section: String, subject: String, professorId: Node?) {
        self.id = nil
        self.uuid = uuid
        self.room = room
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
        self.day = day
        self.section = section
        self.subject = subject
        self.professorId = professorId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        uuid = try node.extract("uuid")
        room = try node.extract("room")
        status = try node.extract("status")
        startTime = try node.extract("start_time")
        endTime = try node.extract("end_time")
        day = try node.extract("day")
        section = try node.extract("section")
        subject = try node.extract("subject")
        professorId = try node.extract("professor_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        print("Track this three")
        return try Node(node:
            [
                "id" : id,
                "uuid" : uuid,
                "room" : room,
                "status" : status,
                "start_time" : startTime,
                "end_time" : endTime,
                "day" : day,
                "section" : section,
                "subject" : subject,
                "professor_id" : professorId,
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("schedules", closure: { (schedules) in
            schedules.id()
            schedules.string("uuid")
            schedules.string("room")
            schedules.string("status")
            schedules.string("start_time")
            schedules.string("end_time")
            schedules.string("day")
            schedules.string("section")
            schedules.string("subject")
            schedules.parent(Professor.self, optional: false)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("schedules")
    }
}

extension Professor {
    func schedules() throws -> [Schedule] {
        return try children(nil, Schedule.self).all()
    }
}

extension Schedule {
    func professor() throws -> Professor? {
         return try parent(professorId, nil, Professor.self).get()
    }
}
