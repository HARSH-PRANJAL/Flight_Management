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
        let menu = FlightManagerMenu.allCases

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                      Flight Manager Menu
                ===============================
                """
        )

        let route = AirportRouteGraph()
        let choice = IO.readInt(
            size: menu.count
        )
        let option = menu[choice - 1]

        switch option {

        case .viewFlights:
            if let flightId = IO.readOptional(
                msg: "Do you want to see specific flight details? (y/n) : ",
                readValue: { IO.readInt(prompt: "Enter flight id : ") }
            ) {
                if let flight = findFlightById(id: flightId) {
                    print(flight)
                } else {
                    print("\n🚨 Error: Flight not found ‼️\n")
                }
            } else {
                let allFlights = getAllFlights()
                IO.displayTable(
                    allFlights,
                    heading: "Flights",
                    failMsg: "No flights available."
                )
            }

        case .scheduleFlight:
            let allAirports = getAllAirports().sorted(by: { a, b in a.id < b.id
            })
            let allAircrafts = getAllAircrafts().sorted(by: { a, b in
                a.id < b.id
            })

            IO.displayTable(
                allAirports,
                heading: "Airports",
                failMsg: "No airports available."
            )
            IO.displayTable(
                allAircrafts,
                heading: "Aircrafts",
                failMsg: "No aircrafts available."
            )

            let sourceId = IO.readInt(prompt: "Enter source airport id : ")
            let destinationId = IO.readInt(
                prompt: "Enter destination airport id : "
            )
            let allRoutes = route.getRoutes(from: sourceId, to: destinationId)
            IO.displayTable(
                allRoutes,
                heading: "Routes",
                failMsg: "No suitable routes available."
            )

            let routeChoice = IO.readInt(
                prompt: "Enter route number : ",
                size: allRoutes.count
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
            let allAirports = getAllAirports().sorted(by: { a, b in a.id < b.id
            })
            IO.displayTable(
                allAirports,
                heading: "Airports",
                failMsg: "No airports available."
            )

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
        let menu = HRMenu.allCases

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                            HR Menu
                ===============================
                """
        )

        let choice = IO.readInt(size: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .viewAllEmployees:
            let allCrew = getAllCrew().sorted(by: { a, b in a.id < b.id })
            IO.displayTable(
                allCrew,
                heading: "Crew",
                failMsg: "No crew members found."
            )

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
        let menu = GroundStaffMenu.allCases

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                       Front Desk Menu
                ===============================
                """
        )

        let choice = IO.readInt(size: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .addPassenger:
            do {
                let passengerId = try initiateUserRegistration(true)
                print(
                    "Passenger with ID \(passengerId) has been added successfully."
                )
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch let error as DataError {
                print("\n🚨 Error: \(error) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

        case .cancelBooking:
            print("Not implemented")

        case .viewAvailableFlights:
            let allFlights = getAllFlights()
            IO.displayTable(
                allFlights,
                heading: "Flights",
                failMsg: "No flights available."
            )

        case .viewAvailableSeats:
            let ops1 = IO.readOptional(
                msg:
                    "Do you want to view seats by source id (y/n) : ",
                readValue: {
                    IO.readInt(prompt: "Enter source id", terminator: "")
                }
            )
            let ops2: Int
            var currFlights: [Flight] = []

            if ops1 == nil {
                ops2 = IO.readInt(prompt: "Enter flight Id : ")
                if let flight = findFlightById(id: ops2) {
                    currFlights.append(flight)
                } else {
                    print("\n🚨 Error: No flights available ‼️\n")
                }
            } else {
                ops2 = IO.readInt(prompt: "Enter destination id : ")
                let flights = getFlightsBetween(
                    sourceId: ops1!,
                    destinationId: ops2
                )
                currFlights.append(contentsOf: flights)
            }

            for flight in currFlights {
                guard let aircraft = findAircraftById(id: flight.aircraftId)
                else {
                    continue
                }

                print(aircraft.describeRemainingSeats)
            }

        case .viewPassengerBookings:
            let userId = IO.readInt(prompt: "Enter passenger id : ")
            if !passengers.keys.contains(userId) {
                print("\n🚨 Error: Passenger not found ‼️\n")
                continue
            }

            let allBookings = getBookingsForPassenger(id: userId)
            IO.displayTable(
                allBookings,
                heading: "Passenger Bookings",
                failMsg: "No bookings found for this passenger."
            )

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
        let menu = PassengerMenu.allCases

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                       Passenger Menu
                ===============================
                """
        )

        let choice = IO.readInt(size: menu.count)
        let option = menu[choice - 1]

        switch option {
        case .bookTicket:
            let allAirports = getAllAirports()
            IO.displayTable(
                allAirports,
                heading: "Available Airports",
                failMsg: "No airports available."
            )

            let sourceId = IO.readInt(prompt: "Enter the source airport id: ")
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
            guard let user = authenticatedUser,
                let passenger = user as? Passenger
            else {
                print("You are not authorised for this action. 🔐")
                continue
            }

            let bookingId = IO.readInt(prompt: "Enter the Ticket number : ")
            guard let booking = findBookingById(id: bookingId) else {
                print("No booking found with the given id.")
                continue
            }

            do {
                let isCancelled = try passenger.cancelTkt(booking: booking)

                if isCancelled {
                    print("Ticket Cancelled. 🚫")
                }
            } catch let error {
                print(
                    "\n🚨 Error: \(error) You are not authorised to cancel this tkt. ‼️\n"
                )
            }

        case .viewBookings:
            let allBookings = getBookingsForPassenger(id: passenger.id)
            IO.displayTable(
                allBookings,
                heading: "Your bookings",
                failMsg: "You have no bookings."
            )

        case .exit:
            return
        }
    }
}
