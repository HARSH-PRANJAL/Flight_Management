import Foundation

func registerFlight(
    aircraftId: Int,
    scheduledDeparture: Date,
    route: Route
) -> Int? {
    guard var aircraft = findAircraftById(withId: aircraftId) else {
        return nil
    }
    
    if !aircraft.isAvailable {
        return nil
    } else {
        aircraft.isAvailable = false
    }
    
    let newFlight = Flight(
        aircraftId: aircraftId,
        scheduledDeparture: scheduledDeparture,
        route: route
    )

    flights[newFlight.id] = newFlight
    return newFlight.id
}

func findFlightById(_ id: Int) -> Flight? {
    return flights[id]
}

func getAllFlights() -> [Flight] {
    return Array(flights.values)
}

func deleteFlightById(id: Int) -> Int? {
    if let flight = flights.removeValue(forKey: id) {
        return flight.id
    } else {
        return nil
    }
}
