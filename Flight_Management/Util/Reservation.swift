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

    Flight.displayFlightsRemainingSeats(allFlights)

    let flightId = IO.readInt(prompt: "Enter the flight ID : ")
    guard let flight = findFlightById(id: flightId),
          flight.route.airportPath.first == sourceId,
          flight.route.airportPath.last == destinationId,
        var aircraft = findAircraftById(id: flight.aircraftId)
    else {
        throw DataError.dataNotFound(
            msg: "Flight not exist."
        )
    }
    
    let remainingSeats = aircraft.seatingCapacity
    if remainingSeats == 0 {
        print("No seats available in selected aircraft.")
        return false
    }

    var count = IO.readInt(prompt: "Enter the number of tickets to book : ",size: remainingSeats)

    var currBookings: [Booking] = []
    var i = 1
    while i <= count {
        if remainingSeats == 0 {
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
        let choice = IO.readInt(size: seatMenu.count)
        let seatPreference: SeatPreference = seatMenu[choice - 1]

        if !aircraft.allocateSeat(preference: seatPreference, count: 1) {
            print(
                "No seat available for passenger \(i) with seat preference \(seatPreference). ‼️"
            )
            print("Book next ticket.")
            continue
        }

        var mealPreference: MealPreference? = nil

        let ops = IO.readString(
            prompt: "Do you want to provide meal preference ? (y/n) : ",
            options: ["y", "n"]
        )
        if ops == "y" {
            let mealMenu = MealPreference.allCases

            IO.displayOptions(
                options: mealMenu,
                msg: "Select meal preference :"
            )
            let mealChoice = IO.readInt(size: mealMenu.count)
            mealPreference = mealMenu[mealChoice - 1]
        }

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
