struct Aircraft {
    static var nextId: Int = 1
    let id: Int
    let model: String
    let manufacturer: String
    let SeatingCapacity: Int
    let fuelCapacity: Double
    var isAvailable: Bool = true

    init(
        model: String,
        manufacturer: String,
        SeatingCapacity: Int,
        fuelCapacity: Double
    ) {
        self.id = Aircraft.nextId
        Aircraft.nextId += 1
        self.model = model
        self.manufacturer = manufacturer
        self.SeatingCapacity = SeatingCapacity
        self.fuelCapacity = fuelCapacity
    }

    var description: String {
        return """
            Aircraft id : \(id)
            Model: \(model), Manufacturer: \(manufacturer)
            SeatingCapacity: \(SeatingCapacity), FuelCapacity: \(fuelCapacity)
            """
    }
}
