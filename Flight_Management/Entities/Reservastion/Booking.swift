import Foundation

struct Booking: TableRepresentable {
    static var nextTktNumber: Int = 1000
    let tktNumber: Int = {
            let current = Self.nextTktNumber
            Self.nextTktNumber += 1
            return current
        }()
    let passengerId: Int
    let flightId: Int
    let bookingDate: Date
    var cancellationDate: Date?
    var mealPreference: MealPreference
    var seatPreference: SeatPreference
    var totalAmount: Double = 0.0
    let sourceAirportId: Int
    let destinationAirportId: Int
    
    static var tableHeaders: [String] {
        [
            "Ticket Number",
            "Passenger name",
            "Flight ID",
            "Booking Date",
            "Boarding Airport",
            "Destination Airport",
            "Meal Preference",
            "Seat Preference",
            "Total Amount"
        ]
    }
    
    var tableRow: [String] {
        [
            String(tktNumber),
            String(passengerName),
            String(flightId),
            String(formatDateTime(bookingDate)),
            String(sourceAirport),
            String(destinationAirport),
            String(mealPreference.description),
            String(seatPreference.description),
            String(totalAmount)
        ]
    }
    
    var passengerName: String {
        if let passenger = findUserById(by: passengerId) {
            return passenger.name
        } else {
            return "Unknown"
        }
    }
    
    var sourceAirport: String {
        if let airport = findAirportById(id: sourceAirportId) {
            return airport.name
        } else {
            return "Unknown"
        }
    }
    
    var destinationAirport: String {
        if let airport = findAirportById(id: destinationAirportId) {
            return airport.name
        } else {
            return "Unknown"
        }
    }
}
