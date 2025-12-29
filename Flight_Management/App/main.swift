// caching authenticated users token
var tokens: Set<Int> = []
// caching all passengers
var passengers: [Int: Passenger] = [:]
// caching all crew members (pilot, cabin crew, ground staff)
var crews: [Int: Crew] = [:]

func main() {
    while true {
        IO.displayEnumOptions(enumType: MainMenu.self, msg:
            """
            ===============================
                       Main Menu
            ===============================
            """)
        
        let choice = IO.readEnumOption(enumSize: MainMenu.allCases.count)
        let option = MainMenu.allCases[choice - 1]

        switch option {
        case .crewLogin:
            print("Crew login not implemented yet.")
        case .passengerLogin:
            print("Passenger login not implemented yet.")
        case .registerUser:
            do {
                let newId = try initiateUserRegistration()
                print("\nUser registered with ID: \(newId) ✅")
            } catch let error {
                print("\n🚨 Error: \(error.description) ‼️\n")
            }
        }
    }
}

main()
