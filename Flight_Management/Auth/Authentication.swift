func authenticateUser(userId: Int, password: String) throws -> Bool {
    guard let user = findUserById(by: userId) else {
        throw UserError.userNotFound
    }
    
    if !user.verifyPassword(password) {
        throw AuthError.invalidPassword
    }
    
    if user is Passenger {
        userRole = nil
    } else {
        userRole = (user as! Crew).crewType
    }
    
    if user is Crew && userRole == nil {
        return false
    }
    
    return true
}

func passwordHash(password: String) -> String {
    return String(password.hashValue)
}
