enum AuthError: Error {
    case invalidPassword
    case authenticationFailed
    case unauthorised
    
    var description: String {
        switch self {
        case .invalidPassword:
            return "Invalid password"
        case .authenticationFailed:
            return "Authentication failed"
        case .unauthorised:
            return "Not authorised for this action"
        }
    }
}
