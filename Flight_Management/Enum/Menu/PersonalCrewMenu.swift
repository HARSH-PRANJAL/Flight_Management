enum ProfileMenu: CaseIterable, CustomStringConvertible {
    case applyForLeave
    case resign
    case workMenu
    case logout

    var description: String {
        switch self {
        case .applyForLeave:
            return "Apply for leave"
        case .resign:
            return "Resign"
        case .logout:
            return "Logout"
        case .workMenu:
            return "Open work menu"
        }
    }
}
