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
        print("Track this two")
        print("1")
        id = try node.extract("id")
        print("2")
        firstName = try node.extract("firstname")
        print("3")
        middleName = try node.extract("middlename")
        print("4")
        lastName = try node.extract("lastname")
        print("5")
        department = try node.extract("department")
        print("6")
        profilePictureUrl = try node.extract("profilepictureurl")
        print("7")
    }
    
    func makeNode(context: Context) throws -> Node {
        print("Track this three")
        return try Node(node:
            [
                "id" : id,
                "firstname" : firstName,
                "middlename" : middleName,
                "lastname" : lastName,
                "department" : department,
                "profile_picture_url" : profilePictureUrl
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("professors", closure: { (professors) in
            professors.id()
            professors.string("firstname")
            professors.string("middlename")
            professors.string("lastname")
            professors.string("department")
            professors.string("profile_picture_url")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("professors")
    }
}
