import Foundation

func isAircraftExist(id: Int) -> Bool {
    return aircrafts.keys.contains(id)
}

func isAircraftAvailable(id: Int) -> Bool {
    aircrafts[id]?.isAvailable ?? false
}

func findAircraftById(id: Int) -> Aircraft? {
    return aircrafts[id]
}

func getAllAircrafts() -> [Aircraft] {
    return Array(aircrafts.values).sorted(by: { a, b in a.id < b.id
    })
}

func registerAircraft(
    model: String,
    manufacturer: String,
    economySeat: Int,
    businessSeat: Int,
    firstClassSeat: Int,
    fuelCapacity: Double
) -> Int {
    let newAircraft = Aircraft(
        model: model,
        manufacturer: manufacturer,
        economySeat: economySeat,
        businessSeat: businessSeat,
        firstClassSeat: firstClassSeat,
        fuelCapacity: fuelCapacity
    )

    aircrafts[newAircraft.id] = newAircraft
    return newAircraft.id
}

func registerMaintenanceLog(
    aircraftId: Int,
    scheduledDate: Date,
    expectedCompletionDate: Date
) -> Int? {

    guard var aircraft = findAircraftById(id: aircraftId) else {
        return nil
    }

    if !aircraft.isAvailable {
        return nil
    } else {
        aircraft.markAsUnavailable()
        aircrafts[aircraft.id] = aircraft
    }

    let newMaintenanceLog = MaintenanceLog(
        aircraftId: aircraftId,
        scheduledDate: scheduledDate,
        expectedCompletionDate: expectedCompletionDate
    )

    maintenanceLogs[newMaintenanceLog.id] = newMaintenanceLog
    return newMaintenanceLog.id
}

func updateAircraft(aircraft: Aircraft) -> Bool {
    if aircrafts.keys.contains(aircraft.id) {
        aircrafts[aircraft.id] = aircraft
        return true
    } else {
        return false
    }
}
