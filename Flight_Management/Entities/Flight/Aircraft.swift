struct Aircraft: CustomStringConvertible, TableRepresentable {
    static var nextId: Int = 1
    let id: Int
    let model: String
    let manufacturer: String
    // [seat type : (total seat, remaining seats)]
    var seat: [SeatPreference: (Int, Int)] = [:]
    let fuelCapacity: Double
    var isAvailable: Bool = true

    init(
        model: String,
        manufacturer: String,
        economySeat: Int = 0,
        businessSeat: Int = 0,
        firstClassSeat: Int = 0,
        seatingCapacity: Int = 0,
        fuelCapacity: Double
    ) {
        self.id = Aircraft.nextId
        Aircraft.nextId += 1
        self.model = model
        self.manufacturer = manufacturer
        self.fuelCapacity = fuelCapacity
        self.createSeats(economySeat, businessSeat, firstClassSeat)
    }

    var description: String {
        return """
            Aircraft id : \(id)
            Model: \(model), Manufacturer: \(manufacturer)
            SeatingCapacity: \(seatingCapacity), FuelCapacity: \(fuelCapacity)
            """
    }

    static var tableHeaders: [String] {
        ["ID", "Model", "Manufacturer", "Capacity", "Fuel Capacity"]
    }

    var tableRow: [String] {
        [
            String(id),
            model,
            manufacturer,
            String(seatingCapacity),
            String(fuelCapacity),
        ]
    }

    var describeRemainingSeats: String {
        var result = ""
        
        result.append("\(SeatPreference.economy): \(seat[.economy]?.1 ?? 0), ")
        result.append("\(SeatPreference.business): \(seat[.business]?.1 ?? 0), ")
        result.append("\(SeatPreference.firstClass): \(seat[.firstClass]?.1 ?? 0)")
        
        return result
    }
    
    var seatingCapacity: Int {
        return seat.values.reduce(0) { $0 + $1.1 }
    }
    
    mutating func allocateSeat(preference: SeatPreference, count: Int) -> Bool {
        guard let (total, available) = self.seat[preference] else {
            return false
        }
        
        guard available >= count else {
            return false
        }
        
        self.seat[preference] = (total, available - count)
        return updateAircraft(aircraft: self)
    }
    
    mutating func markAsUnavailable() {
        self.isAvailable = false
        updateAircraft(aircraft: self)
    }
    
    private mutating func createSeats(
        _ economySeat: Int,
        _ businessSeat: Int,
        _ firstClassSeat: Int
    ) {
        self.seat[.economy] = (economySeat, economySeat)
        self.seat[.business] = (businessSeat, businessSeat)
        self.seat[.firstClass] = (firstClassSeat, firstClassSeat)
    }
}
