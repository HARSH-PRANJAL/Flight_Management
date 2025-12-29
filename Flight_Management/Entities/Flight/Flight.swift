import Foundation

class Flight {
    static var nextId: Int = 1
    let id: Int
    let aircraftId: Int
    let sourceAirportId: Int
    var destinationAirportId: Int
    var scheduledDeparture: Date
    var scheduledArrival: Date
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
            sourceAirportId: \(sourceAirportId), destinationAirportId: \(destinationAirportId)
            scheduledDeparture: \(scheduledDeparture), scheduledArrival: \(scheduledArrival)
            """
    }
}
