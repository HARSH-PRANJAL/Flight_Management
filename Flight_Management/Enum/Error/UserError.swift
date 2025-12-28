enum UserError: Error {
    case registrationFailed
    
    var description: String {
        switch self {
        case .registrationFailed:
            return "Registration failed."
        }
    }
}
