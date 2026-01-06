func findBookingById(id: Int) -> Booking? {
    return bookings[id]
}

func getBookingsForPassenger(id: Int) -> [Booking] {
    guard let user = findUserById(by: id),
          let passenger = user as? Passenger else {
        return []
    }
    
    var result: [Booking] = []
    for bookingId in passenger.ticketIds {
        if let curr = findBookingById(id: bookingId) {
            result.append(curr)
        }
    }
    
    return result.sorted(by: { a, b in a.bookingDate > b.bookingDate
    })
}

func deleteBookingById(id: Int) -> Booking? {
    return bookings.removeValue(forKey: id)
}

func findBillById(id: Int) -> Transaction? {
    return transactions[id]
}

func updateBooking(booking: Booking) -> Bool {
    if bookings.keys.contains(booking.tktNumber) {
        bookings[booking.tktNumber] = booking
        return true
    } else {
        return false
    }
}
