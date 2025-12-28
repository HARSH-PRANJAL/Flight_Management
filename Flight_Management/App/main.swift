// caching authenticated users token
var tokens: Set<Int> = []
// caching all passengers
var passengers: [Int: Passenger] = [:]
// caching all crew members (pilot, cabin crew, ground staff)
var crews: [Int: Crew] = [:]

func main() {
    while true {
        print(
            """
            ===============================
                       Main Menu
            ===============================
            """
        )

        for (i, option) in MainMenu.allCases.enumerated() {
            print("\(i+1) \(option.description)")
        }

        print("Enter choice : ", terminator: " ")
        let choice = IO.readInt()

        if choice <= 0 || choice > MainMenu.allCases.count {
            print(" Wrong choice ‼️ ")
            print(" Try again ")
            continue
        }

        let option = MainMenu.allCases[choice - 1]

        switch option {
        case .crewLogin:
        case .passengerLogin:
        }
    }
}
