struct DefaultAircraftRepo {
    static var aircrafts: [Int: Aircraft] = [:]

    func isAircraftExist(witId id: Int) -> Bool {
        return Self.aircrafts.keys.contains(id)
    }

    func registerAircraft(
        model: String,
        manufacturer: String,
        seatingCapacity: Int,
        fuelCapacity: Double
    ) -> Int {

        let newAircraft = Aircraft(
            model: model,
            manufacturer: manufacturer,
            SeatingCapacity: seatingCapacity,
            fuelCapacity: fuelCapacity
        )

        Self.aircrafts[newAircraft.id] = newAircraft
        return newAircraft.id
    }
}
