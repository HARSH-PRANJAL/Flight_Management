func findUser(by id: Int) -> User? {
    if let passenger = passengers[id] {
        return passenger
    }
    if let crew = crews[id] {
        return crew
    }
    return nil
}

