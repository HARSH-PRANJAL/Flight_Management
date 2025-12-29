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
        
        let choice = IO.readEnumOption(enumType: MainMenu.self)
        let option = MainMenu.allCases[choice - 1]

        switch option {
        case .crewLogin:
        case .passengerLogin:
        case .registerUser:
        }
    }
}
