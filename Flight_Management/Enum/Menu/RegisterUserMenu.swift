enum RegisterUserMenu: CaseIterable, CustomStringConvertible {
    case registerCrew
    case registerPassenger
    
    var description: String {
        switch self {
        case .registerCrew:
            return "Register Crew"
        case .registerPassenger:
            return "Register Passenger"
        }
    }
}
