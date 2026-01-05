enum PassengerMenu: CaseIterable, CustomStringConvertible {
    case bookTicket
    case cancelTicket
    case viewBookings
    case Logout
    
    
    var description: String {
        switch self {
        case .bookTicket:
            return "Book tickets"
        case .cancelTicket:
            return "Cancel a ticket"
        case .viewBookings:
            return "View all bookings"
        case .Logout:
            return "Logout"
        }
    }
}
