import Foundation

struct Booking: TableRepresentable {
    static var nextTktNumber: Int = 1000
    let tktNumber: Int = {
            let current = Self.nextTktNumber
            Self.nextTktNumber += 1
            return current
        }()
    let passengerId: Int
    let name: String
    let flightId: Int
    let bookingDate: Date
    var cancellationDate: Date?
    var mealPreference: MealPreference
    var seatPreference: SeatPreference
    let sourceAirportId: Int
    let destinationAirportId: Int
    let transactionId: Int
    
    static var tableHeaders: [String] {
        [
            "Ticket Number",
            "Name",
            "Flight ID",
            "Booked on",
            "Boarding",
            "Destination",
            "Meal",
            "Seat",
            "Amount"
        ]
    }
    
    var tableRow: [String] {
        [
            String(tktNumber),
            String(name),
            String(flightId),
            String(formatDateTime(bookingDate, format: "dd-MM-yyyy")),
            String(sourceAirport),
            String(destinationAirport),
            String(mealPreference.description),
            String(seatPreference.description),
            String(format: "%.2f", amount)
        ]
    }
    
    var sourceAirport: String {
        if let airport = findAirportById(id: sourceAirportId) {
            return airport.airportCode
        } else {
            return "Unknown"
        }
    }
    
    var destinationAirport: String {
        if let airport = findAirportById(id: destinationAirportId) {
            return airport.airportCode
        } else {
            return "Unknown"
        }
    }
    
    var amount: Double {
        guard let bill = findBillById(id: transactionId) else {
            return 0.0
        }
        
        return bill.amount
    }
}
