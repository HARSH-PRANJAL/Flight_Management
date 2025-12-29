enum UserError: Error {
    case registrationFailed
    case dobBelowMinimum
    case userNotFound
    
    var description: String {
        switch self {
        case .registrationFailed:
            return "Registration failed."
        case .dobBelowMinimum:
            return "DOB is below minimum."
        case .userNotFound:
            return "User not found."
        }
    }
}
