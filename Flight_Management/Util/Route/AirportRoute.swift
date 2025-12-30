// route will be created and stored here. Flights will run on these routes
struct AirportRouteGraph {

    private static var graph: [Int: [RouteEdge]] = [:]

    func addRoute(
        from sourceId: Int,
        to destinationId: Int,
        fare: Double,
        durationHours: Double
    ) {
        let edge = RouteEdge(
            fromAirportId: sourceId,
            toAirportId: destinationId,
            fare: fare,
            durationHours: durationHours
        )

        Self.graph[sourceId, default: []].append(edge)
    }
}
