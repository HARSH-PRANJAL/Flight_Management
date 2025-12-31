import Foundation

class Passenger: User {
    static var nextId: Int = 1
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

    var ticketIds: [Int] = []
    var luggageId: Int? = nil
    var mealPreferences: MealPreference = .veg
    var seatPreferences: SeatPreference = .any

    init(
        dob: Date,
        gender: Gender,
        name: String,
        email: String,
        password: String,
        phone: String,
        idProof: String? = nil,
        idProofType: IdProofType? = nil,
        address: String? = nil
    ) {
        self.id = Passenger.nextId
        Passenger.nextId += 1
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
    }
    
    var description: String {
        return "Passenger data display"
    }
}
