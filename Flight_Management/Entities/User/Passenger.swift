import Foundation

class Passenger: User {
    let id: Int
    let createdAt: Date
    let dob: Date
    let gender: Gender
    var name: String
    var updatedAt: Date
    var idProof: String?
    var idProofType: IdProofType?
    var address: String?
    var phone: String?
    var email: String
    var password: String
    
    var ticketIds: [Int] = []
    var luggageId: Int? = nil
    var mealPreferences: MealPreference = .veg
    var seatPreferences: SeatPreference = .any

    init(
        id: Int,
        dob: Date,
        gender: Gender,
        name: String,
        email: String,
        password: String,
        idProof: String? = nil,
        idProofType: IdProofType? = nil,
        address: String? = nil,
        phone: String? = nil,
        role: String? = nil
    ) {
        self.id = id
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
}
