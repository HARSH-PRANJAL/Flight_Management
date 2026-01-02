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
    var mealPreference: MealPreference = .veg
    
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

    static var tableHeaders: [String] {
        ["ID", "Name", "Gender", "Phone number"]
    }

    var tableRow: [String] {
        [
            String(id),
            name,
            gender.description,
            phone,
        ]
    }

    func bookTkt(
        flight: Flight,
        bookingDate: Date?,
        mealPreference: MealPreference?,
        seatPreference: SeatPreference,
        sourceId: Int,
        destinationId: Int
    ) -> Booking {
        let totalAmount = flight.route.totalFare * seatPreference.rawValue + (mealPreference?.rawValue ?? 0.0)
        
        let transaction = Transaction(amount: totalAmount, type: .payment, userId: self.id)
        transactions[transaction.id] = transaction
        
        let booking = Booking(
            passengerId: self.id,
            flightId: flight.id,
            bookingDate: bookingDate ?? Date(),
            mealPreference: mealPreference ?? self.mealPreference,
            seatPreference: seatPreference,
            sourceAirportId: sourceId,
            destinationAirportId: destinationId
        )

        bookings[booking.tktNumber] = booking
        return booking
    }
    
//    func cancelTkt(bookingId: Int) throws -> Bool {
//        guard let bill = findBillById(id: bookingId) else {
//            throw DataError.dataNotFound(msg: "Booking is not availabel")
//        }
//        let transaction = Transaction(amount: bill.total, type: .payment, userId: self.id)
//        transactions[transaction.id] = transaction
//    }
}
