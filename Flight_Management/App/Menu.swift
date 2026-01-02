import Foundation

func crewMenu() {
    guard let role = userRole else {
        return
    }

    if role == .flightManager {
        flightManagerMenu()
    } else if role == .hr {
        hrMenu()
    } else if role == .groundStaff {
        groundStaffMenu()
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
                let allFlights = getAllFlights()
                IO.displayTable(allFlights, heading: "Flights")
            }

        case .scheduleFlight:
            let allAirports = getAllAirports()
            let allAircrafts = getAllAircrafts()

            IO.displayTable(allAirports, heading: "Airports")
            IO.displayTable(allAircrafts, heading: "Aircrafts")

            let sourceId = IO.readInt(prompt: "Enter source airport id : ")
            let destinationId = IO.readInt(
                prompt: "Enter destination airport id : "
            )
            let allRoutes = route.getRoutes(from: sourceId, to: destinationId)
            print("\n")
            IO.displayTable(allRoutes, heading: "Routes")

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
            let allAirports = getAllAirports()
            IO.displayTable(allAirports, heading: "Airports")

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

func hrMenu() {
    while true {
        IO.displayEnumOptions(
            enumType: HRMenu.self,
            msg:
                """
                ===============================
                            HR Menu
                ===============================
                """
        )

        let menu = HRMenu.allCases
        let choice = IO.readOptionNumber(size: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .viewAllEmployees:
            let allCrew = getAllCrew()
            IO.displayTable(allCrew, heading: "Crew")

        case .viewAllResignationRequests:
            for request in resignationRequests {
                guard let user = findUserById(by: request),
                    let crew = user as? Crew
                else {
                    continue
                }

                print(crew, terminator: "\n\n")
            }

        case .viewAllLeaveRequests:
            for request in leaveRequests {
                guard let user = findUserById(by: request.key),
                    let crew = user as? Crew
                else {
                    continue
                }

                print("\(crew.name) - \(request.value)", terminator: "\n")
            }

        case .approveLeaveRequest:
            let crewId = IO.readInt(
                prompt:
                    "Enter the ID of the crew member to approve a leave request for: "
            )
            if leaveRequests.keys.contains(crewId) {
                guard let user = findUserById(by: crewId),
                    let crew = user as? Crew
                else {
                    print("Crew Id is invalid")
                    leaveRequests.removeValue(forKey: crewId)
                    continue
                }

                crew.isAvailable = false
            }

        case .approveResignationRequest:
            let crewId = IO.readInt(
                prompt:
                    "Enter the ID of the crew member to approve a resignation request for: "
            )
            if resignationRequests.contains(crewId) {
                guard let user = findUserById(by: crewId),
                    let crew = user as? Crew
                else {
                    print("Crew Id is invalid")
                    resignationRequests.remove(crewId)
                    continue
                }

                crew.isAvailable = false
                crew.resignDate = Date()
            }

        case .addSalaryToCrew:
            print("To be implemented")

        case .exit:
            return
        }
    }
}

func groundStaffMenu() {
    while true {
        IO.displayEnumOptions(
            enumType: HRMenu.self,
            msg:
                """
                ===============================
                       Front Desk Menu
                ===============================
                """
        )

        let menu = GroundStaffMenu.allCases
        let choice = IO.readOptionNumber(size: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .addPassenger:
            do {
                let passengerId = try initiateUserRegistration(true)
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .cancelBooking:
            print("Not implemented")

        case .viewAvailableFlights:
            let allFlights = getAllFlights()
            IO.displayTable(allFlights, heading: "Flights")

        case .viewAvailableSeats:
            let ops1 = IO.readOptional(
                msg:
                    "Select Y to find seats by flightId or N to find seats by source and destination",
                readValue: { IO.readInt(prompt: "Enter source Id") }
            )
            let ops2: Int
            var currFlights: [Flight] = []

            if ops1 == nil {
                ops2 = IO.readInt(prompt: "Enter flight Id : ")
                if let flight = findFlightById(ops2) {
                    currFlights.append(flight)
                } else {
                    print("\n🚨 Error: No flights available ‼️\n")
                }
            } else {
                ops2 = IO.readInt(prompt: "Enter destination Id : ")
                let flights = getFlightsBetween(
                    sourceId: ops1!,
                    destinationId: ops2
                )
                currFlights.append(contentsOf: flights)
            }

            for flight in currFlights {
                guard let aircraft = findAircraftById(withId: flight.aircraftId)
                else {
                    continue
                }

                print(aircraft.describeRemainingSeats)
            }

        case .viewPassengerBookings:
            let userId = IO.readInt(prompt: "Enter passenger Id : ")
            if !passengers.keys.contains(userId) {
                print("\n🚨 Error: Passenger not found ‼️\n")
                continue
            }

            let allBookings = getBookingsForPassenger(id: userId)
            IO.displayTable(allBookings, heading: "Passenger Bookings")

        case .exit:
            return
        }
    }
}

func passengerMenu() {
    guard let user = authenticatedUser,
        let passenger = user as? Passenger
    else {
        print("You are not authenticated to access this menu. 🔐")
        return
    }
    while true {
        IO.displayEnumOptions(
            enumType: PassengerMenu.self,
            msg:
                """
                ===============================
                       Passenger Menu
                ===============================
                """
        )

        let menu = PassengerMenu.allCases
        let choice = IO.readOptionNumber(size: menu.count)
        let option = menu[choice - 1]

        switch option {
        case .bookTicket:
            let allAirports = getAllAirports()
            IO.displayTable(allAirports, heading: "Available Airports")

            let sourceId = IO.readInt(prompt: "Enter the source airport Id: ")
            let destinationId = IO.readInt(
                prompt: "Enter the destination airport Id: "
            )

            do {
                let isCompleted = try initiateTktBooking(
                    sourceId: sourceId,
                    destinationId: destinationId
                )
                if isCompleted {
                    print("Booking Completed. ✅")
                }
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch let error as AuthError {
                print("\n🚨 Error: \(error) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .cancelTicket:
            let bookingId = IO.readInt(prompt: "Enter the booking Id : ")
            guard let user = authenticatedUser,
            let passenger = user as? Passenger
            else {
                print("You are not authorised for this action. 🔐")
                continue
            }
            
//            passenger.cancelTicket(bookingId: bookingId)
            print("Not implemented")
            
        case .viewBookings:
            let allBookings = getBookingsForPassenger(id: passenger.id)
            IO.displayTable(allBookings, heading: "Your bookings")

        case .exit:
            return
        }
    }
}
