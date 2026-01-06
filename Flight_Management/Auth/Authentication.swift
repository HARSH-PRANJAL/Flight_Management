func authenticateUser(userId: Int, password: String) throws -> Bool {
    guard let user = findUserById(by: userId) else {
        throw UserError.userNotFound
    }
    
    if !user.verifyPassword(password) {
        throw AuthError.invalidPassword
    }
    
    return true
}

func passwordHash(password: String) -> String {
    return String(password.hashValue)
}
