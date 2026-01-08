enum MealPreference: Double, CaseIterable, CustomStringConvertible {
    case veg = 300
    case nonVeg = 500
    case vegan = 1200
    case none = 0
    
    var description: String {
        switch self {
        case .veg:
            return "Vegetarian"
        case .nonVeg:
            return "Non-Vegetarian"
        case .vegan:
            return "Vegan"
        case .none:
            return "Don't want any meal"
        }
    }
}

enum SeatPreference: Double, CaseIterable, CustomStringConvertible {
    case economy = 1
    case business = 2.5
    case firstClass = 4.25

    var description: String {
        switch self {
        case .economy:
            return "Economy"
        case .business:
            return "Business"
        case .firstClass:
            return "First Class"
        }
    }
}
