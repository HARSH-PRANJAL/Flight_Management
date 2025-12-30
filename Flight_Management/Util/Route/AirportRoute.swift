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
            toAirportId: destinationId,
            fare: fare,
            durationHours: durationHours
        )

        Self.graph[sourceId, default: []].append(edge)
    }

    func getRouteEdges(from airportId: Int) -> [RouteEdge] {
        Self.graph[airportId] ?? []
    }

    func getRoutes(from sourceId: Int, to destinationId: Int) -> [Route] {
        var routes: [Route] = []
        var visited: Set<Int> = []
        dfs(
            current: sourceId,
            destinationId: destinationId,
            path: [sourceId],
            totalFare: 0,
            totalDuration: 0,
            visited: &visited,
            accumulate: &routes
        )
        return routes
    }

}

extension AirportRouteGraph {
    fileprivate func dfs(
        current: Int,
        destinationId: Int,
        path: [Int],
        totalFare: Double,
        totalDuration: Double,
        visited: inout Set<Int>,
        accumulate routes: inout [Route]
    ) {
        if current == destinationId {
            let airportPath = path
            routes.append(
                Route(
                    airportPath: airportPath,
                    totalDuration: totalDuration,
                    totalFare: totalFare
                )
            )
            return
        }

        visited.insert(current)
        for edge in getRouteEdges(from: current) {
            let next = edge.toAirportId
            if !visited.contains(next) {
                dfs(
                    current: next,
                    destinationId: destinationId,
                    path: path + [next],
                    totalFare: totalFare + edge.fare,
                    totalDuration: totalDuration + edge.durationHours,
                    visited: &visited,
                    accumulate: &routes
                )
            }
        }
        visited.remove(current)
    }
}
