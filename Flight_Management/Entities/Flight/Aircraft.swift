struct Aircraft: CustomStringConvertible,TableRepresentable {
    static var nextId: Int = 1
    let id: Int
    let model: String
    let manufacturer: String
    let seatingCapacity: Int
    let fuelCapacity: Double
    var isAvailable: Bool = true

    init(
        model: String,
        manufacturer: String,
        seatingCapacity: Int,
        fuelCapacity: Double
    ) {
        self.id = Aircraft.nextId
        Aircraft.nextId += 1
        self.model = model
        self.manufacturer = manufacturer
        self.seatingCapacity = seatingCapacity
        self.fuelCapacity = fuelCapacity
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
                String(fuelCapacity)
            ]
        }
}
