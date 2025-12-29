import Foundation

struct DefaultFlightRepo {
    static var flights: [Int : Flight] = [:]
    
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
        
        DefaultFlightRepo.flights[newFlight.id] = newFlight
        return newFlight.id
    }
    
    func findFlightById(_ id: Int) -> Flight? {
        return DefaultFlightRepo.flights[id]
    }
    
    func getAllFlights() -> [Flight] {
        return Array(DefaultFlightRepo.flights.values)
    }
}
