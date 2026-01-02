struct Aircraft: CustomStringConvertible, TableRepresentable {
    static var nextId: Int = 1
    let id: Int
    let model: String
    let manufacturer: String
    // [seat type : (total seat, remaining seats)]
    var seat: [SeatPreference: (Int, Int)] = [:]
    let fuelCapacity: Double
    var isAvailable: Bool = true
    let seatingCapacity: Int

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
        self.seatingCapacity = max(economySeat + businessSeat + firstClassSeat,seatingCapacity)
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

    mutating func createSeats(
        _ economySeat: Int,
        _ businessSeat: Int,
        _ firstClassSeat: Int
    ) {
        self.seat[.economy] = (economySeat, 0)
        self.seat[.business] = (businessSeat, 0)
        self.seat[.firstClass] = (firstClassSeat, 0)
    }

    var describeRemainingSeats: String {
        var result = ""
        
        for (pref, count) in seat {
            result.append("\(pref) : \(count.1)\n")
        }
        
        return result
    }
    
    mutating func allocateSeat(preference: SeatPreference, count: Int) -> Bool {
        guard var (total, available) = self.seat[preference] else {
            return false
        }
        
        guard available >= count else {
            return false
        }
        
        self.seat[preference] = (total, available - count)
        return true
    }
}
