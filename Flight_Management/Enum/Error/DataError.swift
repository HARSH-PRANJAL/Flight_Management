enum DataError: Error {
    case dataNotFound(msg: String)
    case invalidData(msg: String)
}
