func isAircraftExist(witId id: Int) -> Bool {
    return aircrafts.keys.contains(id)
}

func isAircraftAvailable(withId id: Int) -> Bool {
    if let aircraft = aircrafts[id] {
        return aircraft.isAvailable
    }
    
    return false
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

    aircrafts[newAircraft.id] = newAircraft
    return newAircraft.id
}
