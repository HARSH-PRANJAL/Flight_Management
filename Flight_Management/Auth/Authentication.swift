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
    
    tokens.insert(userId)
    return true
}

func authenticateToken(token: Int) throws -> Bool {
    if tokens.contains(token) {
        return true
    } else {
        throw AuthError.authenticationFailed
    }
}
