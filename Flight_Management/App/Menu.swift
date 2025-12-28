func registerUser() {
    while true {
        print(
            """
            ===============================
                  Registration Menu
            ===============================
            """
        )
        
        let menu = RegisterUserMenu.allCases
        
        for (i, option) in menu.enumerated() {
            print("\(i+1) \(option.description)")
        }

        print("Enter choice : ", terminator: " ")
        let choice = IO.readInt()

        if choice <= 0 || choice > menu.count {
            print(" Wrong choice ‼️ ")
            print(" Try again ")
            continue
        }

        let option = menu[choice - 1]

        switch option {
        case .registerCrew:
            initiateCrewRegistration()
        case .registerPassenger:
            initiatePassengerRegistration()
        }
    }
}
