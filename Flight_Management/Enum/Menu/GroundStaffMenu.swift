enum GroundStaffMenu: CaseIterable, CustomStringConvertible {
    case addPassenger
    case bookFlight
    case cancelBooking
    case viewAvailableFlights
    case viewPassengerBookings
    case exit
    
    var description: String {
        switch self {
        case .addPassenger:
            return "Add Passenger"
        case .bookFlight:
            return "Book Flight"
        case .cancelBooking:
            return "Cancel Booking"
        case .viewAvailableFlights:
            return "View Available Flights"
        case .viewPassengerBookings:
            return "View Passenger Bookings"
        case .exit:
            return "Exit"
        }
    }
}
