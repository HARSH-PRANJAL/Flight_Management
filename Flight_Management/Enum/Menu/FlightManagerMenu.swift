enum FlightManagerMenu: CaseIterable, CustomStringConvertible {
    case viewFlights
    case scheduleFlight
    case cancelFlight
    case createJourney
    case addAirport
    case addAircraft
    case scheduleMaintenance

    var description: String {
        switch self {
        case .viewFlights: 
            return "View flights"
        case .scheduleFlight:
            return "Schedule flight"
        case .cancelFlight:
            return "Cancel flight"
        case .createJourney:
            return "Create journey"
        case .addAirport:
            return "Add new airport"
        case .addAircraft:
            return "Add new aircraft"
        case .scheduleMaintenance:
            return "Schedule maintenance"
        }
    }
}
