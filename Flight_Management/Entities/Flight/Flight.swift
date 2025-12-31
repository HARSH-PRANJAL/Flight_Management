import Foundation

struct Flight: CustomStringConvertible, TableRepresentable {
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
        self.scheduledArrival = scheduledDeparture.addingTimeInterval(
            route.totalDuration * 3600
        )
    }

    var sourceAirport: String {
        guard let id = route.airportPath.first,
            let airport = findAirportById(id: id)
        else {
            return ""
        }

        return airport.airportCode
    }

    var destinationAirport: String {
        guard let id = route.airportPath.last,
            let airport = findAirportById(id: id)
        else {
            return ""
        }

        return airport.airportCode
    }

    var description: String {
        return """
            Flight id : \(id)
            Aircraft id : \(aircraftId)
            Source Airport : \(sourceAirport)
            destination Airport : \(destinationAirport)
            Scheduled Departure : \(String(formatDateTime(scheduledDeparture)))
            Scheduled Arrival : \(String(formatDateTime(scheduledArrival)))
            """
    }

    static var tableHeaders: [String] {
        ["ID", "Aircraft ID", "Departure", "Source", "Arrival", "Destination"]
    }

    var tableRow: [String] {
        [
            String(id),
            String(aircraftId),
            String(formatDateTime(scheduledDeparture)),
            sourceAirport,
            String(formatDateTime(scheduledArrival)),
            destinationAirport,
        ]
    }
}
