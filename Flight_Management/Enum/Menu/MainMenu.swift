enum MainMenu: CaseIterable, CustomStringConvertible {
    case passengerLogin
    case crewLogin
    case registerUser
    
    var description: String {
        switch self {
        case .passengerLogin:
            return "Passenger Login"
        case .crewLogin:
            return "Crew Login"
        case .registerUser:
            return "Register User"
        }
    }
}
