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
    var isAvailable: Bool = true

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
        self.password = String(password.hashValue)
        self.crewType = crewType
    }

    var description: String {
        return """
            Crew id : \(id)
            Name : \(name)
            Joined on : \(String(formatDateTime(joiningDate)))
            Designation : \(crewType)
            Total flight hours : \(totalFlightHours ?? 0)
            Total ground hours : \(totalGroundHours ?? 0)
            """
    }

    static var tableHeaders: [String] {
        ["ID", "Name", "Designation", "Flight Hrs", "Ground Hrs"]
    }

    var tableRow: [String] {
        [
            String(id),
            name,
            crewType.description,
            String(format: "%.1f", totalFlightHours ?? 0),
            String(format: "%.1f", totalGroundHours ?? 0),
        ]
    }

    func requestForResignation() {
        resignationRequests.insert(self.id)
    }
}
