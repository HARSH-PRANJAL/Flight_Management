enum HRMenu: CaseIterable, CustomStringConvertible {
    case viewAllEmployees
    case viewAllResignationRequests
    case viewAllLeaveRequests
    case approveLeaveRequest
    case approveResignationRequest
    case addSalaryToCrew
    case exit

    var description: String {
        switch self {
        case .viewAllEmployees: 
            return "View All Employees"
        case .viewAllResignationRequests: 
            return "View All Resignation Requests"
        case .viewAllLeaveRequests: 
            return "View All Leave Requests"
        case .approveLeaveRequest: 
            return "Approve Leave Request"
        case .approveResignationRequest:
            return "Approve Resignation Request"
        case .addSalaryToCrew:
            return "Add Salary to Crew"
        case .exit:
            return "Exit"
        }
    }
}
