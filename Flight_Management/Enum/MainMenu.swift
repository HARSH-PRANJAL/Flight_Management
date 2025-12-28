enum MainMenu: String, CaseIterable {
    case passengerLogin
    case crewLogin
    
    var description: String {
        switch self {
        case .passengerLogin:
            return "Passenger Login"
        case .crewLogin:
            return "Crew Login"
        }
    }
}
