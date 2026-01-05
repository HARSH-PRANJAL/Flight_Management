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

    for flight in flights {
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

    guard var aircraft = findAircraftById(id: flight.aircraftId) else {
        throw DataError.invalidData(msg: "No aircraft exists for this flight")
    }

    let bookingDate = IO.readOptional(
        msg: "Select Y to enter a specific booking date",
        readValue: { IO.readDate(dateFormat: "dd-mm-yyyy",prompt: "Enter the booking date : ") }
    )

    let mealMenu = MealPreference.allCases
    let choice = IO.readOptional(
        msg: "Select Y to provide meal preference",
        readValue: {
            IO.displayOptions(
                options: mealMenu,
                msg: "Select meal preference : "
            )
            return IO.readInt(
                size: mealMenu.count
            )
        }
    )

    let mealPreference: MealPreference? =
        choice != nil ? mealMenu[choice! - 1] : nil

    let count = IO.readInt(prompt: "Enter the number of tickets to book : ")

    var currBookings: [Booking] = []
    var i = 1
    while i <= count {
        let seatMenu = SeatPreference.allCases
        
        IO.displayOptions(
            options: seatMenu,
            msg: "Select seat preference for passenger \(i) :"
        )
        let choice = IO.readInt(size: seatMenu.count)
        let seatPreference: SeatPreference = seatMenu[choice - 1]

        if !aircraft.allocateSeat(preference: seatPreference, count: 1) {
            print(
                "No seat available for passenger \(i) with seat preference \(seatPreference). ‼️"
            )
            continue
        }

        let booking = passenger.bookTkt(
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
