// caching authenticated users token
var tokens: Set<Int> = []
// caching all passengers
var passengers: [Int: Passenger] = [:]
// caching all crew members (pilot, cabin crew, ground staff)
var crews: [Int: Crew] = [:]
// store user role after auth for role based menu options
var userRole: CrewType?
var authenticatedUser: User?

func main() {
    while true {
        IO.displayEnumOptions(
            enumType: MainMenu.self,
            msg:
                """
                ===============================
                           Main Menu
                ===============================
                """
        )

        let choice = IO.readEnumOption(enumSize: MainMenu.allCases.count)
        let option = MainMenu.allCases[choice - 1]

        switch option {
        case .crewLogin:
            let userID = IO.readInt(prompt: "Enter your ID : ")
            let password = IO.readString(prompt: "Enter your password : ")

            do {
                if try authenticateUser(userId: userID, password: password) {
                    authenticatedUser = userRole != nil ? crews[userID]! : passengers[userID]!
                }
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch let error as AuthError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print("\n🚨 An unexpected error occurred. Please try again later. ‼️\n")
            }
            
            crewMenu()
        case .passengerLogin:
            print("Passenger login not implemented yet.")
        case .registerUser:
            do {
                let newId = try initiateUserRegistration()
                print("\nUser registered with id : \(newId) ✅")
            } catch let error {
                print("\n🚨 Error: \(error.description) ‼️\n")
            }
        }
    }
}

main()
