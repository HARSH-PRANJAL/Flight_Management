enum AuthError: Error {
    case invalidPassword
    case authenticationFailed
    
    var description: String {
        switch self {
        case .invalidPassword:
            return "Invalid password"
        case .authenticationFailed:
            return "Authentication failed"
        }
    }
}
