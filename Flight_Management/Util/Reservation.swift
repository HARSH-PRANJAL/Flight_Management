func initiateTktBooking(sourceId: Int, destinationId: Int) throws -> Bool {
    guard
        let passenger = authenticatedUser as? Passenger
    else {
        if let user = authenticatedUser {
            throw DataError.dataNotFound(
                msg: "Passenger not available with id : \(user.id)"
            )
        } else {
            throw AuthError.unauthorised
        }
    }

    let flights = getAllFlights()
    var allFlights: [Flight] = []

    for flight in allFlights {
        if flight.route.airportPath.first == sourceId
            && flight.route.airportPath.last == destinationId
        {
            allFlights.append(flight)
        }
    }

    IO.displayTable(allFlights, heading: "Available Flights")
    let flightId = IO.readInt(prompt: "Enter the flight ID : ")
    guard let flight = findFlightById(flightId) else {
        throw DataError.dataNotFound(
            msg: "No flight exists with ID : \(flightId)"
        )
    }

    guard var aircraft = findAircraftById(withId: flight.aircraftId) else {
        throw DataError.invalidData(msg: "No aircraft exists for this flight")
    }

    let bookingDate = IO.readOptional(
        msg: "Select Y to enter a specific booking date",
        readValue: { IO.readDate(prompt: "Enter the booking date : ") }
    )

    let mealMenu = MealPreference.allCases
    var choice = IO.readOptional(
        msg: "Select Y to provide meal preference",
        readValue: {
            IO.displayEnumOptions(
                enumType: MealPreference.self,
                msg: "Select meal preference : "
            )
            return IO.readOptionNumber(
                size: mealMenu.count,
                msg: "Select meal preference :"
            )
        }
    )

    let mealPreference: MealPreference? =
        choice != nil ? mealMenu[choice! - 1] : nil

    let count = IO.readInt(prompt: "Enter the number of tickets to book : ")

    var currBookings: [Booking] = []
    var i = 1
    while i <= count {
        IO.displayEnumOptions(
            enumType: SeatPreference.self,
            msg: "Select seat preference for passenger \(i) :"
        )
        let seatMenu = SeatPreference.allCases
        let choice = IO.readOptionNumber(size: seatMenu.count)
        let seatPreference: SeatPreference = seatMenu[choice - 1]

        if !aircraft.allocateSeat(preference: seatPreference, count: 1) {
            print(
                "No seat available for passenger \(i) with seat preference \(seatPreference). ‼️"
            )
            continue
        }
        
        let totalAmount = flight.route.totalFare * seatPreference.rawValue + (mealPreference?.rawValue ?? 0.0)
        var booking = passenger.bookTkt(
            flight: flight,
            bookingDate: bookingDate,
            mealPreference: mealPreference,
            seatPreference: seatPreference,
            sourceId: sourceId,
            destinationId: destinationId
        )
        
        currBookings.append(booking)
        i += 1
    }
    
    IO.displayTable(currBookings, heading: "Current Bookings")
    return true
}
