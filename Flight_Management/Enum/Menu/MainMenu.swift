enum MainMenu: CaseIterable, CustomStringConvertible {
    case passengerLogin
    case crewLogin
    case registerCrew
    case registerPassenger
    case exit
    
    var description: String {
        switch self {
        case .passengerLogin:
            return "Passenger Login"
        case .crewLogin:
            return "Crew Login"
        case .registerCrew:
            return "Register Crew"
        case .registerPassenger:
            return "Register Passenger"
        case .exit:
            return "Exit"
        }
    }
}
