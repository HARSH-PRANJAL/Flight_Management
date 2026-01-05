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
        seatingCapacity: seatingCapacity,
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

func updateCompletionDateOfLog(logId: Int, newCompletionDate: Date) -> Bool {
    guard var log = maintenanceLogs[logId] else {
        return false
    }

    log.completionDate = newCompletionDate
    maintenanceLogs[logId] = log
    return true
}
