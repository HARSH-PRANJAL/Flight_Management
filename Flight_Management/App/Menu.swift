func crewMenu() {
    guard let role = userRole else {
        return
    }

    if role == .flightManager {
        flightManagerMenu()
    }
}

func flightManagerMenu() {
    while true {
        IO.displayEnumOptions(
            enumType: FlightManagerMenu.self,
            msg:
                """
                ===============================
                      Flight Manager Menu
                ===============================
                """
        )

        let route = AirportRouteGraph()
        let choice = IO.readOptionNumber(
            size: FlightManagerMenu.allCases.count
        )
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
                displayAllFlights()
            }

        case .scheduleFlight:
            displayAllAirpots()
            displayAllAircrafts()

            let sourceId = IO.readInt(prompt: "Enter source airport id : ")
            let destinationId = IO.readInt(
                prompt: "Enter destination airport id : "
            )
            let allRoutes = route.getRoutes(from: sourceId, to: destinationId)
            displayRoute(routes: allRoutes)

            let routeChoice = IO.readOptionNumber(
                size: allRoutes.count,
                msg: "Enter route number : "
            )
            let route = allRoutes[routeChoice - 1]

            do {
                let flightId = try initiateFlightRegistration(route: route)
                print("Flight registered with id :  \(flightId) ✅")
            } catch let error as DataError {
                print("\n🚨 Error: \(error) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .cancelFlight:
            let flightId = IO.readInt(prompt: "Enter flight id to cancel : ")

            if let id = deleteFlightById(id: flightId) {
                print("Flight deleted by id : \(id) ✅")
            } else {
                print("No flight with flight id : \(flightId)")
            }

        case .addRoute:
            displayAllAirpots()

            do {
                let isCompleted = try initiateRouteRegistration()
                if isCompleted {
                    print("New route added ✅")
                }
            } catch let error as DataError {
                print("\n🚨 Error: \(error) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .addAirport:
            let airportId = initiateAirportRegistration()
            print("Airport registered with id :  \(airportId) ✅")

        case .addAircraft:
            let aircraftId = initiateAircraftRegistration()
            print("Aircraft registered with id :  \(aircraftId) ✅")

        case .scheduleMaintenance:
            do {
                let newLogId = try initiateFlightMaintenanceLogRegistration()
                print("Maintenance log created with id :  \(newLogId) ✅")

            } catch let error as DataError {
                print("\n🚨 Error: \(error) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .exit:
            return
        }
    }
}
