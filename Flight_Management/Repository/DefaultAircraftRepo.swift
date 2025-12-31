import Foundation

func isAircraftExist(witId id: Int) -> Bool {
    return aircrafts.keys.contains(id)
}

func isAircraftAvailable(withId id: Int) -> Bool {
    if let aircraft = aircrafts[id] {
        return aircraft.isAvailable
    }

    return false
}

func findAircraftById(withId id: Int) -> Aircraft? {
    return aircrafts[id]
}

func getAllAircrafts() -> [Aircraft] {
    return Array(aircrafts.values)
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

func registerMaintenanceLog(
    aircraftId: Int,
    scheduledDate: Date,
    expectedCompletionDate: Date
) -> Int? {

    guard var aircraft = findAircraftById(withId: aircraftId) else {
        return nil
    }

    if !aircraft.isAvailable {
        return nil
    } else {
        aircraft.isAvailable = false
    }

    let newMaintenanceLog = MaintenanceLog(
        aircraftId: aircraftId,
        scheduledDate: scheduledDate,
        expectedCompletionDate: expectedCompletionDate
    )

    maintenanceLogs[newMaintenanceLog.id] = newMaintenanceLog
    return newMaintenanceLog.id
}

func updateCompletionDateOfLog(logId: Int, newCompletionDate: Date) -> Bool {
    guard var log = maintenanceLogs[logId] else {
        return false
    }

    log.completionDate = newCompletionDate
    maintenanceLogs[logId] = log
    return true
}
