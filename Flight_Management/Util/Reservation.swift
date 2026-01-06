func initiateTktBooking(
    for passenger: Passenger,
    sourceId: Int,
    destinationId: Int
) throws -> Bool {
    let allFlights = getAllFlights().filter { flight in
        flight.route.airportPath.first == sourceId
            && flight.route.airportPath.last == destinationId
    }

    if allFlights.isEmpty {
        print("No flights available.")
        return false
    }

    displayFlightsRemainingSeats(allFlights)

    let flightId = IO.readInt(prompt: "Enter the flight ID : ")
    guard let flight = findFlightById(id: flightId),
        var aircraft = findAircraftById(id: flight.aircraftId)
    else {
        throw DataError.dataNotFound(
            msg: "Flight/Aircraft not exist."
        )
    }

    if aircraft.seatingCapacity == 0 {
        print("No seats available in selected aircraft.")
        return false
    }

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

    if aircraft.seatingCapacity < count {
        let choice = IO.readString(
            prompt:
                "Only available to book \(aircraft.seatingCapacity) tickets. Select y to continue or n to exit (y/n) : "
        ).lowercased()

        if choice == "n" {
            return false
        } else {
            print("Continue Booking ....\n")
        }
    }

    var currBookings: [Booking] = []
    var i = 1
    while i <= count {
        if aircraft.seatingCapacity == 0 {
            print(
                "No more seats available. All previous bookings are confirmed. Exiting..."
            )
            break
        }

        let seatMenu = SeatPreference.allCases

        IO.displayOptions(
            options: seatMenu,
            msg: "Select seat preference for passenger \(i) :"
        )
        var choice = IO.readInt(size: seatMenu.count)
        let seatPreference: SeatPreference = seatMenu[choice - 1]

        if !aircraft.allocateSeat(preference: seatPreference, count: 1) {
            print(
                "No seat available for passenger \(i) with seat preference \(seatPreference). ‼️"
            )
            print("Book next ticket.")
            continue
        }

        let mealMenu = MealPreference.allCases
        let mealChoice = IO.readOptional(
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
            mealChoice != nil ? mealMenu[mealChoice! - 1] : nil

        let name = IO.readString(prompt: "Enter passenger name : ")
        let booking = passenger.bookTkt(
            flight: flight,
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

func displayFlightsRemainingSeats(_ allFlights: [Flight]) {
    var flightTableHeaders: [String] = Flight.tableHeaders
    flightTableHeaders.append("Remaining Seats")

    var flightTableRows: [[String]] = []
    for flight in allFlights {
        var currentRow: [String] = flight.tableRow

        guard let aircraft = findAircraftById(id: flight.aircraftId) else {
            continue
        }

        currentRow.append(aircraft.describeRemainingSeats)
        flightTableRows.append(currentRow)
    }
    IO.displayTable(
        heading: "Flights",
        headers: flightTableHeaders,
        rows: flightTableRows,
        failMsg: "No aircrafts available."
    )
}
