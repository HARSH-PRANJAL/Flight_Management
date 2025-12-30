import Foundation

func registerFlight(
    airCraftId: Int,
    scheduledDeparture: Date,
    route: Route
) -> Int {

    let newFlight = Flight(
        aircraftId: airCraftId,
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
