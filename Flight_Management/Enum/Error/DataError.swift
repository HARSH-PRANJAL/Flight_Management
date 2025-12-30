enum DataError: Error {
    case dataNotFound
    case invalidData
    
    var description: String {
        switch self {
        case .dataNotFound:
            return "Data not found"
        case .invalidData:
            return "Invalid data"
        }
    }
}
