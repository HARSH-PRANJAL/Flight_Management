enum CrewType: CaseIterable {
    case pilot
    case captain
    case flightCrew
    case groundStaff
    case groundedCrew

    var description: String {
        switch self {
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
        }
    }
}
