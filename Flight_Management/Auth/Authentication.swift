func authenticateUser(userId: Int, password: String, crew: Bool = false) throws -> Bool {
    if crew {
        guard let crew = findCrewById(id: userId)
        else {
            throw UserError.userNotFound
        }
        
        if !crew.verifyPassword(password) {
            throw AuthError.authenticationFailed
        }
        authenticatedUser = crew
        userRole = crew.crewType
    } else {
        guard let passenger = findPassengerById(id: userId)
        else {
            throw UserError.userNotFound
        }
        
        if !passenger.verifyPassword(password) {
            throw AuthError.authenticationFailed
        }
        authenticatedUser = passenger
    }
    
    return true
}

func passwordHash(password: String) -> String {
    return String(password.hashValue)
}
