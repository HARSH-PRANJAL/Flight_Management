import Foundation

func loadMockAircrafts() {
    let mockAircraft = [
        Aircraft(
            model: "Mock A30",
            manufacturer: "Airbus",
            seatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A31",
            manufacturer: "Airbus",
            seatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A32",
            manufacturer: "Airbus",
            seatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A33",
            manufacturer: "Airbus",
            seatingCapacity: 150,
            fuelCapacity: 9000
        ),
    ]

    for aircraft in mockAircraft {
        aircrafts[aircraft.id] = aircraft
    }
}

func loadMockAirports() {
    let mockAirports = [
        Airport(
            airportCode: "JFK",
            name: "John F. Kennedy International Airport",
            city: "New York",
            country: "USA"
        ),
        Airport(
            airportCode: "LHR",
            name: "London Heathrow Airport",
            city: "London",
            country: "United Kingdom"
        ),
        Airport(
            airportCode: "HND",
            name: "Haneda Airport",
            city: "Tokyo",
            country: "Japan"
        ),
        Airport(
            airportCode: "DXB",
            name: "Dubai International Airport",
            city: "Dubai",
            country: "United Arab Emirates"
        ),
        Airport(
            airportCode: "CDG",
            name: "Charles de Gaulle Airport",
            city: "Paris",
            country: "France"
        ),
    ]

    for airport in mockAirports {
        airports[airport.id] = airport
    }
}

func loadMockRoutes() {
    let allAirports = getAllAirports()

    guard allAirports.count > 1 else { return }

    let route = AirportRouteGraph()
    let count = allAirports.count

    for i in 0..<count {
        let currentAirport = allAirports[i]

        let nextIndex = (i + 1) % count
        let nextAirport = allAirports[nextIndex]

        let randomFare = Double.random(in: 1000...6000)
        let randomDuration = Double.random(in: 1.5...8.5)

        route.addRoute(
            from: currentAirport.id,
            to: nextAirport.id,
            fare: randomFare,
            durationHours: randomDuration
        )

        if i % Int.random(in: 3...5) == 0 && i != 0 {
            route.addRoute(
                from: currentAirport.id,
                to: allAirports[0].id,
                fare: Double.random(in: 4000...9000),
                durationHours: Double.random(in: 5.0...12.0)
            )
        }
    }
}

func loadMockPassengers() {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.locale = Locale(identifier: "hi_IN")

    guard let dob = formatter.date(from: "12-03-2003") else {
        return
    }

    let mockPassengers = [
        Passenger(
            dob: dob,
            gender: .male,
            name: "Harsh",
            email: "1234adfs@gmail.com",
            password: "123",
            phone: "1234567890"
        ),
        Passenger(
            dob: dob,
            gender: .male,
            name: "Kumar",
            email: "1234adfs@gmail.com",
            password: "123",
            phone: "1234567890"
        ),
        Passenger(
            dob: dob,
            gender: .male,
            name: "Apple",
            email: "1234adfs@gmail.com",
            password: "123",
            phone: "1234567890"
        ),
        Passenger(
            dob: dob,
            gender: .male,
            name: "Orange",
            email: "1234adfs@gmail.com",
            password: "123",
            phone: "1234567890"
        ),
    ]

    for passenger in mockPassengers {
        passengers[passenger.id] = passenger
    }

}

func loadMockMaintenance() {
    let allAircrafts = getAllAircrafts()
    let size = allAircrafts.count

    guard size > 0 else { return }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    formatter.locale = Locale(identifier: "hi_IN")

    var maintenanceRecords: [MaintenanceLog] = []
    var i = 0
    while i < size {
        let aircraft = allAircrafts[i]
        if aircraft.isAvailable {

            guard let scheduledDate = formatter.date(from: "01/01/2026"),
                let expectedCompletionDate = formatter.date(from: "02/02/2026")
            else {
                continue
            }

            maintenanceRecords.append(
                MaintenanceLog(
                    aircraftId: aircraft.id,
                    scheduledDate: scheduledDate,
                    expectedCompletionDate: expectedCompletionDate
                )
            )
        }
        
        // every one of five aircrafts are scheduled for maintenance
        i += 5
    }

    for record in maintenanceRecords {
        maintenanceLogs[record.id] = record
    }
}

func loadMockCrew() {
    let makeDOB = {(year, month, day) in Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!}
    
    let crewMembers: [Crew] = [

        Crew(
            dob: makeDOB(1985, 3, 15),
            gender: .male,
            name: "Rakesh Sharma",
            email: "rakesh.sharma@airline.com",
            password: "password123",
            phone: "9876543210",
            address: "Delhi, India",
            crewType: .flightManager,
            idProof: "DL123456789"
        ),

        Crew(
            dob: makeDOB(1978, 7, 22),
            gender: .male,
            name: "Anil Kapoor",
            email: "anil.kapoor@airline.com",
            password: "pilot@123",
            phone: "9123456789",
            address: "Mumbai, India",
            crewType: .captain,
            idProof: "MH987654321"
        ),

        Crew(
            dob: makeDOB(1990, 1, 5),
            gender: .female,
            name: "Sneha Verma",
            email: "sneha.verma@airline.com",
            password: "crew@456",
            phone: "9012345678",
            address: "Bengaluru, India",
            crewType: .flightCrew,
            idProof: "KA456789123",
            idProofType: .governmentId
        ),

        Crew(
            dob: makeDOB(1988, 11, 30),
            gender: .male,
            name: "Vikram Singh",
            email: "vikram.singh@airline.com",
            password: "ground@789",
            phone: "9345678123",
            address: "Hyderabad, India",
            crewType: .groundStaff
        ),

        Crew(
            dob: makeDOB(1992, 9, 18),
            gender: .female,
            name: "Neha Joshi",
            email: "neha.joshi@airline.com",
            password: "hr@321",
            phone: "9988776655",
            address: "Pune, India",
            crewType: .hr
        )
    ]
    
    for crew in crewMembers {
        crews[crew.id] = crew
    }
}

func loadMockPassenger() {
    let makeDOB = {(year, month, day) in Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!}
    
    let mockPassengers: [Passenger] = [

        Passenger(
            dob: makeDOB(2000, 6, 12),
            gender: .male,
            name: "Amit Kumar",
            email: "amit.kumar@gmail.com",
            password: "amit@123",
            phone: "9876501234",
            idProof: "1234-5678-9012",
            idProofType: .passport,
            address: "Patna, Bihar"
        ),

        Passenger(
            dob: makeDOB(1998, 2, 28),
            gender: .female,
            name: "Priya Mehta",
            email: "priya.mehta@gmail.com",
            password: "priya@456",
            phone: "9123409876",
            idProof: "G1234567",
            idProofType: .passport,
            address: "Ahmedabad, Gujarat"
        ),

        Passenger(
            dob: makeDOB(1985, 12, 9),
            gender: .other,
            name: "Alex Thomas",
            email: "alex.thomas@gmail.com",
            password: "alex@789",
            phone: "9001122334"
        ),

        Passenger(
            dob: makeDOB(1995, 8, 21),
            gender: .female,
            name: "Kavya Nair",
            email: "kavya.nair@gmail.com",
            password: "kavya@321",
            phone: "8899776655",
            idProof: "TN998877665",
            idProofType: .governmentId,
            address: "Kochi, Kerala"
        )
    ]
    
    for passenger in mockPassengers {
        passengers[passenger.id] = passenger
    }
}
