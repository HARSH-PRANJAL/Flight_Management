import Foundation

class Crew: User {
    static var nextId = 1
    let id: Int
    let createdAt: Date
    let dob: Date
    let gender: Gender
    var name: String
    var updatedAt: Date
    var idProof: String?
    var idProofType: IdProofType?
    var address: String?
    var phone: String
    var email: String
    var password: String

    var inAirPayRatePerHour: Double = 0.0
    var groundDutyPayRatePerHour: Double = 0.0
    var resignDate: Date? = nil
    var totalGroundHours: Double? = 0.0
    var totalFlightHours: Double? = 0.0
    var crewType: CrewType
    var availableAfter: Date
    var isAvailable: Bool = true {
        willSet {
            if newValue == true {
                availableAfter = Date()
            }
        }
    }

    var joiningDate: Date {
        return createdAt
    }

    init(
        dob: Date,
        gender: Gender,
        name: String,
        email: String,
        password: String,
        phone: String,
        address: String,
        crewType: CrewType,
        idProof: String? = nil,
        idProofType: IdProofType? = nil
    ) {
        self.id = Crew.nextId
        Crew.nextId += 1
        self.createdAt = Date()
        self.dob = dob
        self.gender = gender
        self.name = name
        self.updatedAt = Date()
        self.idProof = idProof
        self.idProofType = idProofType
        self.address = address
        self.phone = phone
        self.email = email
        self.password = passwordHash(password: password)
        self.crewType = crewType
        self.availableAfter = Date()
    }

    var description: String {
        return """
            Crew id : \(id)
            Name : \(name)
            Joined on : \(String(formatDateTime(joiningDate, format: "dd-MM-yyy")))
            Designation : \(crewType)
            """
    }

    static var tableHeaders: [String] {
        ["ID", "Name", "Designation"]
    }

    var tableRow: [String] {
        [
            String(id),
            name,
            crewType.description,
        ]
    }

    func applyLeave(reason: String, from: Date, to: Date) -> Bool {
        return registerLeaveRequest(leave: (self.id, (reason, from, to)))
    }

    func resign() -> Bool {
        return registerResignation(crewId: self.id)
    }
}
