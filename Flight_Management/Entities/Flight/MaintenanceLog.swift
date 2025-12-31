import Foundation

struct MaintenanceLog {
    static var nextId = 1
    
    let id: Int = {
        let current = MaintenanceLog.nextId
        MaintenanceLog.nextId += 1
        return current
    }()

    var aircraftId: Int
    let scheduledDate: Date
    var completionDate: Date? = nil
    let expectedCompletionDate: Date
}
