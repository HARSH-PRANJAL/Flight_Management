import Foundation

func registerFlight(
    airCraftId: Int,
    sourceId: Int,
    destinationId: Int,
    scheduledDeparture: Date,
    scheduledArrival: Date
) -> Int {

    let newFlight = Flight(
        aircraftId: airCraftId,
        sourceAirportId: sourceId,
        destinationAirportId: destinationId,
        scheduledDeparture: scheduledDeparture,
        scheduledArrival: scheduledArrival
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
