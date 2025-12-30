import Foundation

func loadMockAircrafts() {
    let mockAircraft = [
        Aircraft(
            model: "Mock A30",
            manufacturer: "Airbus",
            SeatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A31",
            manufacturer: "Airbus",
            SeatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A32",
            manufacturer: "Airbus",
            SeatingCapacity: 150,
            fuelCapacity: 9000
        ),
        Aircraft(
            model: "Mock A33",
            manufacturer: "Airbus",
            SeatingCapacity: 150,
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
        assertionFailure("Failed to parse date for mock passenger")
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
