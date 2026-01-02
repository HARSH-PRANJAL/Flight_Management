func findBookingById(id: Int) -> Booking? {
    return bookings[id]
}

func getBookingsForPassenger(id: Int) -> [Booking] {
    let allBookings: [Booking] = Array(bookings.values)
    let result: [Booking] = allBookings.filter({$0.passengerId == id})
    
    return result
}

func findBillById(id: Int) -> Transaction? {
    return transactions[id]
}
