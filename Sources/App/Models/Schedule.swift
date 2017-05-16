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
        startTime = try node.extract("starttime")
        endTime = try node.extract("endtime")
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
                "firstName" : firstName,
                "middleName" : middleName,
                "lastName" : lastName,
                "department" : department,
                "profilePictureUrl" : profilePictureUrl
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("professors", closure: { (professors) in
            professors.id()
            professors.string("firstName")
            professors.string("middleName")
            professors.string("lastName")
            professors.string("department")
            professors.string("profilePictureUrl")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("professors")
    }
}
