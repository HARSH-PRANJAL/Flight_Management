func findBookingById(id: Int) -> Booking? {
    return bookings[id]
}

func getBookingsForPassenger(id: Int) -> [Booking] {
    let allBookings: [Booking] = Array(bookings.values)
    let result: [Booking] = allBookings.filter({$0.passengerId == id})
    
    return result
}

func deleteBookingById(id: Int) -> Booking? {
    return bookings.removeValue(forKey: id)
}

func findBillById(id: Int) -> Transaction? {
    return transactions[id]
}
