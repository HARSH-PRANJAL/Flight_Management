func initiateTktBooking(
    for passenger: Passenger,
    sourceId: Int,
    destinationId: Int
) throws -> Bool {
    let flights = getAllFlights()

    if flights.isEmpty {
        return false
    }

    let allFlights = flights.filter { flight in
        flight.route.airportPath.first == sourceId
            && flight.route.airportPath.last == destinationId
    }

    if allFlights.isEmpty {
        return false
    }

    let flightTableRows = allFlights.map(\.tableRow)
    IO.displayTable(
        heading: "Flights",
        headers: Flight.tableHeaders,
        rows: flightTableRows,
        failMsg: "No aircrafts available."
    )

    let flightId = IO.readInt(prompt: "Enter the flight ID : ")
    guard let flight = findFlightById(id: flightId) else {
        throw DataError.dataNotFound(
            msg: "No flight exists with ID : \(flightId)"
        )
    }

    guard var aircraft = findAircraftById(id: flight.aircraftId) else {
        throw DataError.invalidData(msg: "No aircraft exists for this flight")
    }

    let bookingDate = IO.readOptional(
        msg: "Do you want to enter a booking date (y/n) : ",
        readValue: {
            IO.readDate(
                dateFormat: "dd-mm-yyyy",
                prompt: "Enter the booking date : "
            )
        }
    )

    let mealMenu = MealPreference.allCases
    let choice = IO.readOptional(
        msg: "Do you want to provide a meal preference (y/n) :",
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

    var count = IO.readInt(prompt: "Enter the number of tickets to book : ")
    if count > 4 {
        print("Maximum 4 tickets can be booked at a time. ‼️")
        let choice = IO.readString(
            prompt:
                "Select y to continue booking 4 tickets or n to exit (y/n) :"
        ).lowercased()
        if choice == "y" {
            count = 4
        } else {
            return false
        }
    } else {
        count = max(count, 1)
    }

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
            print("Book next ticket.")
            continue
        }

        let name = IO.readString(prompt: "Enter passenger name : ")
        let booking = passenger.bookTkt(
            flight: flight,
            bookingDate: bookingDate,
            mealPreference: mealPreference,
            seatPreference: seatPreference,
            sourceId: sourceId,
            destinationId: destinationId,
            passengerName: name
        )

        currBookings.append(booking)
        i += 1
    }

    let tableRows = currBookings.map(\.tableRow)
    IO.displayTable(
        heading: "Passenger Bookings",
        headers: Booking.tableHeaders,
        rows: tableRows,
        failMsg: "No bookings found for this passenger."
    )

    return true
}
