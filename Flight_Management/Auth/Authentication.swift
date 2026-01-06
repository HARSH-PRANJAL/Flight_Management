func authenticateUser(userId: Int, password: String, crew: Bool = false) throws -> Bool {
    if crew {
        guard let crew = findCrewById(id: userId)
        else {
            throw UserError.userNotFound
        }
        
        authenticatedUser = crew
        userRole = crew.crewType
        
        return crew.verifyPassword(password)
    } else {
        guard let passenger = findPassengerById(id: userId)
        else {
            throw UserError.userNotFound
        }
        
        authenticatedUser = passenger
        return passenger.verifyPassword(password)
    }
}

func passwordHash(password: String) -> String {
    return String(password.hashValue)
}
