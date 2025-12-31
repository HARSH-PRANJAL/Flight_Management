enum CrewType: CaseIterable, CustomStringConvertible {
    case flightManager
    case pilot
    case captain
    case flightCrew
    case groundStaff
    case groundedCrew
    case hr

    var description: String {
        switch self {
        case .flightManager:
            return "Flight Manager"
        case .pilot:
            return "Pilot"
        case .captain: 
            return "Captain"
        case .flightCrew: 
            return "Flight Crew"
        case .groundStaff: 
            return "Ground Staff"
        case .groundedCrew: 
            return "Grounded Crew"
        case .hr:
            return "HR"
        }
    }
}
