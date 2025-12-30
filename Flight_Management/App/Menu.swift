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
                
                if allFlights.count == 0 {
                    print("\n🚨 No flights available ‼️\n")
                } else {
                    for flight in allFlights {
                        print(flight, terminator: "\n")
                    }
                }
            }
        case .scheduleFlight:
            let allAirports = getAllAirports()
            if allAirports.count == 0 {
                print("\n🚨 No airports available ‼️\n")
                continue
            }
            
            for airport in allAirports {
                print(airport, terminator: "\n")
            }
            
            let sourceId = IO.readInt(prompt: "Enter source airport id : ")
            let destinationId = IO.readInt(prompt: "Enter destination airport id : ")
            let allRoutes = route.getRoutes(from: sourceId, to: destinationId)
            
            for (i,route) in allRoutes.enumerated() {
                print("\(i+1). \(route)", terminator: "\n")
            }
            
            let route = allRoutes[IO.readEnumOption(enumSize: allRoutes.count) - 1]
            
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
            print("not implemented")
        case .addRoute:
            let allAirports = getAllAirports()
            if allAirports.count == 0 {
                print("\n🚨 No airports available ‼️\n")
                continue
            }
            
            for airport in allAirports {
                print(airport, terminator: "\n")
            }
            
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
            print("not implemented")
        case .exit:
            return
        }
    }
}
