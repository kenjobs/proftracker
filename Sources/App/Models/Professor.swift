import Vapor

final class Professor: Model{
    var id: Node?
    var exists: Bool = false
    var firstName: String
    var middleName: String
    var lastName: String
    var department: String
    var profilePictureUrl: String
    
    init(firstName: String, middleName: String, lastName: String, department: String, profilePictureUrl: String) {
        self.id = nil
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.department = department
        self.profilePictureUrl = profilePictureUrl
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        firstName = try node.extract("firstName")
        middleName = try node.extract("middleName")
        lastName = try node.extract("lastName")
        department = try node.extract("department")
        profilePictureUrl = try node.extract("profilePictureUrl")
    }
    
    func makeNode(context: Context) throws -> Node {
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
        try database.create("prfoessors", closure: { (users) in
            users.id()
            users.string("firstName")
            users.string("middleName")
            users.string("lastName")
            users.string("department")
            users.string("profilePictureUrl")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("professors")
    }
}
