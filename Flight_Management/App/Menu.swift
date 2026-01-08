import Foundation

func crewMenu() {
    guard let user = authenticatedUser,
        let crew = user as? Crew
    else {
        print("Please login first.")
        return
    }

    let operation: (() -> Void)?
    var menu: [ProfileMenu] = [.applyForLeave, .resign, .workMenu]

    if userRole == .flightManager {
        operation = { flightManagerMenu() }
    } else if userRole == .hr {
        operation = { hrMenu() }
    } else if userRole == .groundStaff {
        operation = { groundStaffMenu() }
    } else {
        operation = nil
        menu.removeLast()
    }
    menu.append(.logout)

    while true {
        if crew.resignDate != nil {
            authenticatedUser = nil
            userRole = nil
            return
        }

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                      Profile Menu
                ===============================
                """
        )

        let choice = IO.readInt(upperLimit: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .applyForLeave:
            do {
                let isCompleted = try initiateLeaveApplication(for: crew)

                if isCompleted {
                    print("\nLeave applied successfully. ✅\n")
                } else {
                    print(
                        "You have already applied for leave.\nHr will review it soon."
                    )
                }
            } catch let error as DataError {
                print("\n🚨 Error: \(error). Can not apply for leave. \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }

        case .resign:
            if crew.resign() {
                print("\nResignation applied successfully. See you soon. 👋\n")
            } else {
                print(
                    "You have already applied for resignation.\nHr will review it soon."
                )
            }

        case .workMenu:
            if let ops = operation {
                ops()
            }

        case .logout:
            authenticatedUser = nil
            userRole = nil
            print("Logged out successfully.")
            return
        }
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

        let choice = IO.readInt(
            upperLimit: menu.count
        )
        let option = menu[choice - 1]

        switch option {

        case .viewFlights:
            let ops = IO.readString(
                prompt: "Do you want to see specific flight ? (y/n)",
                options: ["n", "y", "Y", "N"]
            ).lowercased()

            if ops == "y" {
                let flightId = IO.readInt(
                    prompt: "Enter flight id : ",
                    lowerLimit: 0,
                    upperLimit: totalNumberOfFlights(),
                    failMsg: "Please enter a valid flight id."
                )

                if let flight = findFlightById(id: flightId) {
                    print("\n\(flight)")
                } else {
                    print("No flight exists with id \(flightId).\n")
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
            let allAircrafts = getAllAircrafts().filter {
                isAircraftAvailable(id: $0.id)
            }

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

            let routeMaker = AirportRouteGraph()
            var allRoutes: [Route]
            var sourceId: Int
            var destinationId: Int

            while true {
                sourceId = readAirportId(
                    "Enter source airport id : ",
                    "Please enter a valid airport id.",
                    allAirports
                )
                destinationId = readAirportId(
                    "Enter destination airport id : ",
                    "Please enter a valid airport id.",
                    allAirports
                )

                allRoutes = routeMaker.getRoutes(
                    from: sourceId,
                    to: destinationId
                )
                if allRoutes.isEmpty {
                    print(
                        "No route found for the provided source and destination."
                    )

                    let ops = IO.readString(
                        prompt: "Do you want to try again ? (y/n) : ",
                        options: ["y", "n", "Y", "N"]
                    ).lowercased()

                    if ops == "y" {
                        continue
                    } else {
                        break
                    }
                } else {
                    break
                }
            }

            if allRoutes.isEmpty {
                continue
            }

            var routeTableHeaders: [String] = ["ID"]
            routeTableHeaders.append(contentsOf: Route.tableHeaders)

            var routeTableRows: [[String]] = []
            for (i, route) in allRoutes.enumerated() {
                var currentRow = ["\(i+1)"]
                currentRow.append(contentsOf: route.tableRow)
                routeTableRows.append(currentRow)
            }

            IO.displayTable(
                heading: "Routes",
                headers: routeTableHeaders,
                rows: routeTableRows,
                failMsg: "No route found."
            )

            let routeChoice = IO.readInt(
                prompt: "Enter route number : ",
                upperLimit: allRoutes.count,
                failMsg: "Please enter a valid route number."
            )
            let route = allRoutes[routeChoice - 1]

            do {
                if let flightId = try initiateFlightRegistration(route: route) {
                    print("Flight registered with id :  \(flightId) ✅")
                } else {
                    print("Fight registration failed.")
                }
            } catch let error as DataError {
                print("\n🚨 Error: \(error)\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later.\n"
                )
            }

        case .cancelFlight:
            let flightId = IO.readInt(
                prompt: "Enter flight id : ",
                lowerLimit: 0,
                upperLimit: totalNumberOfFlights(),
                failMsg: "Please enter a valid flight id."
            )

            if let id = deleteFlightById(id: flightId) {
                print("Flight cancelled with id : \(id) 🚫")
            } else {
                print("No flight exists with id : \(flightId)")
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

            let sourceId = readAirportId(
                "Enter source airport id : ",
                "Source airport does not exist with ",
                allAirports
            )
            let destinationId = readAirportId(
                "Enter destination airport id : ",
                "Destination airport does not exist with ",
                allAirports
            )
            let duration = IO.readDouble(
                prompt: "Enter estimated flight duration in hours : (HH.mm) ",
                failMsg: "Aircraft can not fly for more than 48.0 hours.",
                lowerLimit: 0.0,
                upperLimit: 48.0
            )
            let basePrice = IO.readDouble(
                prompt: "Enter base fare price : ",
                failMsg: "Please provide a valid fare price.",
                lowerLimit: 0.0
            )

            let route = AirportRouteGraph()
            route.addRoute(
                from: sourceId,
                to: destinationId,
                fare: basePrice,
                durationHours: duration
            )
            print("New route added ✅")

        case .addAirport:
            let airportCode = IO.readString(prompt: "Enter airport code : ")
            let name = IO.readString(prompt: "Enter airport name : ")
            let city = IO.readString(prompt: "Enter city name : ")
            let country = IO.readString(prompt: "Enter country name : ")

            let airportId = registerAirport(
                airportCode: airportCode,
                name: name,
                city: city,
                country: country
            )
            print("Airport registered with id :  \(airportId) ✅")

        case .addAircraft:
            let model = IO.readString(prompt: "Enter aircraft model : ")
            let manufacturer = IO.readString(
                prompt: "Enter manufacturer name : "
            )
            let economySeat = IO.readInt(
                prompt: "Enter number of economy seats : ",
                failMsg: "Please enter correct number of seats."
            )
            let businessSeat = IO.readInt(
                prompt: "Enter number of business seats : ",
                failMsg: "Please enter correct number of seats."
            )
            let firstClassSeat = IO.readInt(
                prompt: "Enter number of first class seats : ",
                failMsg: "Please enter correct number of seats."
            )
            let fuelCapacity = IO.readDouble(
                prompt: "Enter total fuel capacity : ",
                failMsg: "Please enter valid fuel capacity."
            )

            let aircraftId = registerAircraft(
                model: model,
                manufacturer: manufacturer,
                economySeat: economySeat,
                businessSeat: businessSeat,
                firstClassSeat: firstClassSeat,
                fuelCapacity: fuelCapacity
            )
            print("Aircraft registered with id :  \(aircraftId) ✅")

        case .scheduleMaintenance:
            do {
                let newLogId = try initiateFlightMaintenanceLogRegistration()
                print("Maintenance log created with id :  \(newLogId) ✅")

            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
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

        let choice = IO.readInt(upperLimit: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .viewAllEmployees:
            let tableRows = getAllCrew().filter({ crew in
                crew.resignDate == nil
            }).map(\.tableRow)

            IO.displayTable(
                heading: "All crew",
                headers: Crew.tableHeaders,
                rows: tableRows,
                failMsg: "No crew found."
            )

        case .viewAllResignationRequests:
            var tableRows: [[String]] = []

            for request in resignationRequests {
                guard let crew = findCrewById(id: request)
                else {
                    continue
                }

                tableRows.append(crew.tableRow)
            }

            IO.displayTable(
                heading: "Resignation Requests",
                headers: Crew.tableHeaders,
                rows: tableRows,
                failMsg: "No registration requests found."
            )

        case .viewAllLeaveRequests:
            let tableHeader: [String] = [
                "ID", "Name", "From", "To", "Designation", "Reason",
            ]
            var tableRows: [[String]] = []

            for request in leaveRequests {
                guard let crew = findCrewById(id: request.key)
                else {
                    continue
                }

                let id = String(crew.id)
                let name = crew.name
                let from = String(
                    formatDateTime(
                        leaveRequests[crew.id]!.1,
                        format: "dd-MM-yyyy"
                    )
                )
                let to = String(
                    formatDateTime(
                        leaveRequests[crew.id]!.2,
                        format: "dd-MM-yyyy"
                    )
                )
                let designation = "\(crew.crewType)"
                let reason = leaveRequests[crew.id]!.0
                let row: [String] = [id, name, from, to, designation, reason]
                tableRows.append(row)
            }

            IO.displayTable(
                heading: "Leave Applications",
                headers: tableHeader,
                rows: tableRows,
                failMsg: "No leave applications found."
            )

        case .approveLeaveRequest:
            let crewId = IO.readInt(
                prompt:
                    "Enter the id of the crew member to approve a leave request for : ",
                failMsg: "Please enter a valid id."
            )

            if leaveRequests.keys.contains(crewId) {
                guard let crew = findCrewById(id: crewId)
                else {
                    print("Crew id is invalid")
                    leaveRequests.removeValue(forKey: crewId)
                    continue
                }

                crew.isAvailable = false
                crews[crew.id] = crew
                print("Leave approved for \(crew.name).")
            } else {
                print("No leave request found for crew with id \(crewId).")
            }

        case .approveResignationRequest:
            let crewId = IO.readInt(
                prompt:
                    "Enter the id of the crew member to approve a resignation request for : ",
                failMsg: "Please enter a valid id."
            )

            if resignationRequests.contains(crewId) {
                guard let crew = findCrewById(id: crewId)
                else {
                    print("Crew id is invalid")
                    resignationRequests.remove(crewId)
                    continue
                }

                crew.isAvailable = false
                crew.resignDate = Date()
                crews[crew.id] = crew
                print("Resignation approved for \(crew.name).")
            }

        case .addSalaryToCrew:
            let crewId = IO.readInt(
                prompt:
                    "Enter the id of the crew member to add salary to : ",
                failMsg: "Please enter a valid id."
            )

            if let crew = findCrewById(id: crewId) {
                print(
                    """
                    Name : \(crew.name)
                    Designation : \(crew.crewType)
                    Ground Duty Pay Per Hour : \(crew.groundDutyPayRatePerHour)
                    Flight Duty Pay Per Hour : \(crew.inAirPayRatePerHour)
                    """
                )

                print(
                    "\nAmounts you will enter will be added to the existing salary of \(crew.name)."
                )

                let groundDutyPayRatePerHour: Double = IO.readDouble(
                    prompt: "Enter Ground Duty Pay Per Hour : ",
                    failMsg: "Please enter a valid salary."
                )
                let inAirPayRatePerHour = IO.readDouble(
                    prompt: "Enter Flight Pay Per Hour : ",
                    failMsg: "Please enter a valid salary."
                )

                crew.groundDutyPayRatePerHour += groundDutyPayRatePerHour
                crew.inAirPayRatePerHour += inAirPayRatePerHour
                crews[crew.id] = crew
            } else {
                print("No crew found for id \(crewId).")
            }

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

        let choice = IO.readInt(upperLimit: menu.count)
        let option = menu[choice - 1]

        switch option {

        case .addPassenger:
            do {
                let passengerId = try initiateUserRegistration(true)
                print(
                    "Passenger with id \(passengerId) has been added successfully."
                )
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) \n")
            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }
        case .bookFlight:
            let passengerId = IO.readInt(
                prompt: "Enter passenger id : ",
                failMsg: "Please enter a valid passenger id."
            )

            guard let passenger = findPassengerById(id: passengerId)
            else {
                print("\n🚨 Error: Passenger does not exist. \n")
                continue
            }

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

            let sourceId = readAirportId(
                "Enter the source airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )
            let destinationId = readAirportId(
                "Enter the destination airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )

            do {
                let isCompleted = try initiateTktBooking(
                    for: passenger,
                    sourceId: sourceId,
                    destinationId: destinationId
                )
                if isCompleted {
                    print("Booking Completed. ✅")
                }
            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }

        case .cancelBooking:
            let passengerId = IO.readInt(prompt: "Enter passenger id : ")

            guard let passenger = findPassengerById(id: passengerId)
            else {
                print("Wrong passenger id or passenger does not exist.")
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
                    "\n🚨 Error: \(error) This ticket is not booked by \(passenger.name). \n"
                )
            }

        case .viewAvailableFlights:
            let choice = IO.readString(
                prompt: "Do you want to view a specific flight (y/n) : ",
                options: ["y", "n"]
            )

            if choice == "y" {
                let flightId = IO.readInt(
                    prompt: "Enter flight id : ",
                    lowerLimit: 0,
                    upperLimit: totalNumberOfFlights(),
                    failMsg: "Please enter a valid flight id."
                )
                guard let flight = findFlightById(id: flightId) else {
                    print("No flight found with the given id.")
                    continue
                }

                Flight.displayFlightsRemainingSeats([flight])
                continue
            }

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

            let sourceId = readAirportId(
                "Enter source airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )
            let destinationId = readAirportId(
                "Enter destination airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )

            let allFlights = getFlightsBetween(
                sourceId: sourceId,
                destinationId: destinationId
            )
            Flight.displayFlightsRemainingSeats(allFlights)

        case .viewPassengerBookings:
            let userId = IO.readInt(prompt: "Enter passenger id : ")
            if !passengers.keys.contains(userId) {
                print("\n🚨 Error: Passenger not found \n")
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

        let choice = IO.readInt(upperLimit: menu.count)
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

            let sourceId = readAirportId(
                "Enter source airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )
            let destinationId = readAirportId(
                "Enter destination airport id : ",
                "Please enter a valid airport id.",
                allAirports
            )

            do {
                let isCompleted = try initiateTktBooking(
                    for: passenger,
                    sourceId: sourceId,
                    destinationId: destinationId
                )

                if isCompleted {
                    print("Booking Completed. ✅")
                } else {

                }
            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }

        case .cancelTicket:
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
                    "\n🚨 Error: \(error) You are not authorised to cancel this tkt. \n"
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
            print("Successfully logged out.")
            return
        }
    }
}
