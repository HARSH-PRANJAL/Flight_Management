import Foundation

struct Flight {
    static var nextId: Int = 1
    let id: Int
    let aircraftId: Int
    let sourceAirportId: Int
    let destinationAirportId: Int
    let scheduledDeparture: Date
    let scheduledArrival: Date
    var isCancelled: Bool = false

    init(
        aircraftId: Int,
        sourceAirportId: Int,
        destinationAirportId: Int,
        scheduledDeparture: Date,
        scheduledArrival: Date
    ) {
        self.id = Flight.nextId
        Flight.nextId += 1
        self.aircraftId = aircraftId
        self.sourceAirportId = sourceAirportId
        self.destinationAirportId = destinationAirportId
        self.scheduledDeparture = scheduledDeparture
        self.scheduledArrival = scheduledArrival
    }

    var description: String {
        return """
            id: \(id)
            aircraftId: \(aircraftId)
            sourceAirportId: \(airports[sourceAirportId]!), destinationAirportId: \(airports[destinationAirportId]!)
            scheduledDeparture: \(scheduledDeparture), scheduledArrival: \(scheduledArrival)
            """
    }
}
