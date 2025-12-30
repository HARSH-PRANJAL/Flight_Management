// to store fare and other details between two airports
struct RouteEdge {
    let fromAirportId: Int
    let toAirportId: Int
    let fare: Double
    let durationHours: Double
}
