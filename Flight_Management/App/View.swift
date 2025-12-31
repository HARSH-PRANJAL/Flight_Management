func displayAllFlights() {
    let allFlights: [Flight] = getAllFlights()
    
    if allFlights.isEmpty {
        print("\n🚨 No flights available ‼️\n")
        return
    }
    
    print("\n")
    for (i,flight) in allFlights.enumerated() {
        print("\(i+1). \(flight)", terminator: "\n\n")
    }
}

func displayAllAircrafts() {
    let allAircrafts: [Aircraft] = getAllAircrafts()
    
    if allAircrafts.isEmpty {
        print("🚨 No Aircrafts Available ‼️")
        return
    }
    
    print("\n")
    for (i,aircraft) in allAircrafts.enumerated() {
        if !aircraft.isAvailable {
            print("Under Maintenance 🔩")
        }
        print("\(i+1). \(aircraft)", terminator: "\n\n")
    }
}

func displayAllAirpots() {
    let allAirports: [Airport] = getAllAirports()
    
    if allAirports.isEmpty {
        print("🚨 No Airports Available ‼️")
        return
    }
    
    print("\n")
    for (i,airport) in allAirports.enumerated() {
        print("\(i+1). \(airport)", terminator: "\n")
    }
}

func displayRoute(routes: [Route]) {
    if routes.isEmpty {
        print("🚨 No Routes Available ‼️")
        return
    }
    
    print("\n")
    for (i,route) in routes.enumerated() {
        print("\(i+1). \(route)", terminator: "\n")
    }
}

func displayAllCrew() {
    let allCrew: [Crew] = getAllCrew()
    
    if allCrew.isEmpty {
        print("🚨 No Crew Available ‼️")
        return
    }
    
    print("\n")
    for (i,crew) in allCrew.enumerated() {
            print("\(i+1). \(crew)", terminator: "\n")
    }
}

