enum DataError: Error, CustomStringConvertible {
    case dataNotFound(msg: String)
    case invalidData(msg: String)
    
    var description: String {
        switch self {
        case .dataNotFound(msg: let msg):
            return "Data not found: \(msg)"
        case .invalidData(msg: let msg):
            return "Invalid data: \(msg)"
        }
    }
}
