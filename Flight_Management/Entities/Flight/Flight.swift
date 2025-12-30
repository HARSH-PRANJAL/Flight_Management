import Foundation

struct Flight {
    static var nextId: Int = 1
    let id: Int
    let aircraftId: Int
    let scheduledDeparture: Date
    let scheduledArrival: Date
    var route: Route

    init(
        aircraftId: Int,
        scheduledDeparture: Date,
        route: Route
    ) {
        self.id = Flight.nextId
        Flight.nextId += 1
        self.aircraftId = aircraftId
        self.scheduledDeparture = scheduledDeparture
        self.route = route
        self.scheduledArrival = scheduledDeparture.addingTimeInterval(route.totalDuration * 3600)
    }

    var description: String {
        guard let sourceAirportId = route.airportPath.first,
              let destinationAirportId = route.airportPath.last else {
            return "No airports in route. Flight can not be described."
        }
        
        return """
            id: \(id)
            aircraftId: \(aircraftId)
            sourceAirportId: \(airports[sourceAirportId]!), destinationAirportId: \(airports[destinationAirportId]!)
            scheduledDeparture: \(scheduledDeparture), scheduledArrival: \(scheduledArrival)
            """
    }
}
