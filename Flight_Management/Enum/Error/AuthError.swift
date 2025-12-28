enum AuthError: Error {
    case invalidPassword
    case authenticationFailed
    case userNotFound
    
    var description: String {
        switch self {
        case .invalidPassword:
            return "Invalid password"
        case .authenticationFailed:
            return "Authentication failed"
        case .userNotFound:
            return "User not found"
        }
    }
}
