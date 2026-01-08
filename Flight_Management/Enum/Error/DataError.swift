enum DataError: Error, CustomStringConvertible {
    case dataNotFound(msg: String)
    case invalidData(msg: String)

    var description: String {
        switch self {
        case .dataNotFound(let msg):
            return "Data not found. \(msg)"
        case .invalidData(let msg):
            return "Invalid data. \(msg)"
        }
    }
}
