func crewMenu() {
    guard let role = userRole else {
        return
    }

    if role == .flightManager {
        flightManagerMenu()
    }
}

func flightManagerMenu() {

    IO.displayEnumOptions(
        enumType: FlightManagerMenu.self,
        msg:
            """
            ===============================
                  Flight Manager Menu
            ===============================
            """
    )

    let choice = IO.readEnumOption(enumSize: FlightManagerMenu.allCases.count)
    let option = FlightManagerMenu.allCases[choice - 1]

    switch option {
    case .viewFlights:

        if let flightId = IO.readOptional(
            msg: "Select N to view all flights",
            readValue: { IO.readInt(prompt: "Enter flight id : ") }
        ) {
            if let flight = findFlightById(flightId) {
                print(flight)
            } else {
                print("\n🚨 Error: Flight not found ‼️\n")
            }
        } else {
            let allFlights = getAllFlights()

            for flight in allFlights {
                print(flight, terminator: "\n")
            }
        }

    case .scheduleFlight:
        print("not implemented")
    case .cancelFlight:
        let flightId = IO.readInt(prompt: "Enter flight id to cancel : ")

        if let flight = findFlightById(flightId) {
            flight.isCancelled = true
        } else {
            print("\n🚨 Error: Flight not found ‼️\n")
        }
    case .createJourney:
        print("not implemented")
    case .addAirport:
        initiateAirportRegistration()
    case .addAircraft:
        let aircraftId = initiateAircraftRegistration()
        print("Aircraft registered with id :  \(aircraftId) ✅")
    case .scheduleMaintenance:
        print("not implemented")
    }
}
