import Foundation

func crewMenu() {
    guard let user = authenticatedUser,
        let crew = user as? Crew,
        let role = userRole,
        role == crew.crewType
    else {
        print("Unauthorised Please login first.")
        return
    }

    let ops = IO.readInt(
        prompt:
            "Press 1 to go to personal menu, or any other number to go to work menu : "
    )

    if ops != 1 {
        if role == .flightManager {
            flightManagerMenu()
        } else if role == .hr {
            hrMenu()
        } else if role == .groundStaff {
            groundStaffMenu()
        }
    }

    let menu = ProfileMenu.allCases
    IO.displayOptions(
        options: menu,
        msg:
            """
            ===============================
                  Profile Menu
            ===============================
            """
    )

    let choice = IO.readInt(size: menu.count)
    let option = menu[choice - 1]

    switch option {
    case .applyForLeave:
        let reason = IO.readString(prompt: "Enter reason for leave : ")
        let fromDate = IO.readDate(
            dateFormat: "dd-mm-yyyy",
            prompt: "From (dd-mm-yyyy) : "
        )
        let toDate = IO.readDate(
            dateFormat: "dd-mm-yyyy",
            prompt: "To (dd-mm-yyyy) : "
        )

        if crew.applyLeave(reason: reason, from: fromDate, to: toDate) {
            print("Leave applied successfully.")
        } else {
            print(
                "You have already applied for leave.\nHr will review it soon."
            )
        }
    case .resign:
        if crew.resign() {
            print("Resignation applied successfully. See you soon!")
        } else {
            print(
                "You have already applied for resignation.\nHr will review it soon."
            )
        }
    case .logout:
        authenticatedUser = nil
        userRole = nil
        print("Logged out successfully.")
        return
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
                let tableRow = allFlights.map(\.tableRow)
                IO.displayTable(
                    heading: "Flights",
                    headers: Flight.tableHeaders,
                    rows: tableRow,
                    failMsg: "No flights available."
                )
            }

        case .scheduleFlight:
            let allAirports = getAllAirports()
            let allAircrafts = getAllAircrafts()

            let airportTableRows = allAirports.map(\.tableRow)
            IO.displayTable(
                heading: "Airports",
                headers: Airport.tableHeaders,
                rows: airportTableRows,
                failMsg: "No airports available."
            )

            let aircraftTableRows = allAircrafts.map(\.tableRow)
            IO.displayTable(
                heading: "Aircrafts",
                headers: Aircraft.tableHeaders,
                rows: aircraftTableRows,
                failMsg: "No aircrafts available."
            )

            let sourceId = IO.readInt(prompt: "Enter source airport id : ")
            let destinationId = IO.readInt(
                prompt: "Enter destination airport id : "
            )
            let allRoutes = route.getRoutes(from: sourceId, to: destinationId)
            let routeTableRows = allRoutes.map(\.tableRow)
            IO.displayTable(
                heading: "Routes",
                headers: Route.tableHeaders,
                rows: routeTableRows,
                failMsg: "No route found."
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
            let allAirports = getAllAirports()
            let tableRows = allAirports.map(\.tableRow)
            IO.displayTable(
                heading: "Airports",
                headers: Airport.tableHeaders,
                rows: tableRows,
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
            let allCrew = getAllCrew()
            let tableRows = allCrew.map(\.tableRow)
            IO.displayTable(
                heading: "All crew",
                headers: Crew.tableHeaders,
                rows: tableRows,
                failMsg: "No crew found."
            )

        case .viewAllResignationRequests:
            var allCrew: [Crew] = []
            for request in resignationRequests {
                guard let user = findUserById(by: request),
                    let crew = user as? Crew
                else {
                    continue
                }

                allCrew.append(crew)
            }

            let tableHeader: [String] = ["ID", "Name", "Designation"]
            var tableRows: [[String]] = []

            for crew in allCrew {
                let id = String(crew.id)
                let name = crew.name
                let designation = crew.crewType.description

                let row: [String] = [id, name, designation]
                tableRows.append(row)
            }

            IO.displayTable(
                heading: "Resignation Requests",
                headers: tableHeader,
                rows: tableRows,
                failMsg: "No registration requests found."
            )

        case .viewAllLeaveRequests:
            var allCrew: [Crew] = []

            for request in leaveRequests {
                guard let user = findUserById(by: request.key),
                    let crew = user as? Crew
                else {
                    continue
                }

                allCrew.append(crew)
            }

            var tableHeader: [String] = [
                "ID", "Name", "From", "To", "Designation",
            ]
            var tableRows: [[String]] = []

            for crew in allCrew {
                let id = String(crew.id)
                let name = crew.name
                let from = String(formatDateTime(leaveRequests[crew.id]!.1))
                let to = String(formatDateTime(leaveRequests[crew.id]!.2))
                let designation = crew.crewType.description

                let row: [String] = [id, name, from, to, designation]
                tableRows.append(row)
            }

            IO.displayTable(
                heading: "Leave Applications",
                headers: tableHeader,
                rows: tableRows,
                failMsg: "No leave application."
            )

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
            } else {
                print("No leave request found for that ID")
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
            let tableRows = allFlights.map(\.tableRow)

            IO.displayTable(
                heading: "Flights",
                headers: Flight.tableHeaders,
                rows: tableRows,
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
            let tableRows = allBookings.map(\.tableRow)

            IO.displayTable(
                heading: "Passenger Bookings",
                headers: Booking.tableHeaders,
                rows: tableRows,
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
            if allAirports.isEmpty {
                print("No airports available for booking.")
                continue
            }

            let tableRows = allAirports.map(\.tableRow)
            IO.displayTable(
                heading: "All Airports",
                headers: Airport.tableHeaders,
                rows: tableRows,
                failMsg: "No airports found."
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
                } else {
                    print("No flights available for the selected airports. 😔")
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
            let tableRows = allBookings.map(\.tableRow)

            IO.displayTable(
                heading: "Passenger Bookings",
                headers: Booking.tableHeaders,
                rows: tableRows,
                failMsg: "No bookings found for this passenger."
            )

        case .Logout:
            authenticatedUser = nil
            return
        }
    }
}
