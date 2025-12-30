enum FlightManagerMenu: CaseIterable, CustomStringConvertible {
    case viewFlights
    case scheduleFlight
    case cancelFlight
    case addAirport
    case addAircraft
    case addRoute
    case scheduleMaintenance
    case exit

    var description: String {
        switch self {
        case .viewFlights:
            return "View flights"
        case .scheduleFlight:
            return "Schedule flight"
        case .cancelFlight:
            return "Cancel flight"
        case .addAirport:
            return "Add new airport"
        case .addAircraft:
            return "Add new aircraft"
        case .addRoute:
            return "Add new route"
        case .scheduleMaintenance:
            return "Schedule maintenance"
        case .exit:
            return "Exit"
        }
    }
}
