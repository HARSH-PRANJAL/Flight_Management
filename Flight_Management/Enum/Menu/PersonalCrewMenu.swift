enum ProfileMenu: CaseIterable, CustomStringConvertible {
    case applyForLeave
    case resign
    case logout

    var description: String {
        switch self {
        case .applyForLeave:
            return "Apply for leave"
        case .resign:
            return "Resign"
        case .logout:
            return "Logout"
        }
    }
}
