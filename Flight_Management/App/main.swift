// caching authenticated users token
var tokens: Set<Int> = []
// store user role after auth for role based menu options
var userRole: CrewType?
var authenticatedUser: User?

// cached data
var crews: [Int: Crew] = [:]
var passengers: [Int: Passenger] = [:]
var flights: [Int: Flight] = [:]
var airports: [Int: Airport] = [:]
var aircrafts: [Int: Aircraft] = [:]
var maintenanceLogs: [Int: MaintenanceLog] = [:]
var resignationRequests: Set<Int> = []
var leaveRequests: [Int : String] = [:]
var bookings: [Int : Booking] = [:]
var transactions: [Int: Transaction] = [:]

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

        let choice = IO.readOptionNumber(size: MainMenu.allCases.count)
        let option = MainMenu.allCases[choice - 1]

        switch option {
            
        case .crewLogin:
            let userID = IO.readInt(prompt: "Enter your ID : ")
            let password = IO.readString(prompt: "Enter your password : ")

            do {
                if try authenticateUser(userId: userID, password: password) {
                    authenticatedUser =
                        userRole != nil
                        ? crews[userID]!
                        : passengers[userID]!
                }
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch let error as AuthError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }

            crewMenu()
            
        case .passengerLogin:
            print("Passenger login not implemented yet.")
            
        case .registerUser:
            do {
                let newId = try initiateUserRegistration()
                print("\nUser registered with id : \(newId) ✅")
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }
        }
    }
}

//main()
loadMockAirports()
loadMockAircrafts()
loadMockRoutes()
flightManagerMenu()
//loadMockMaintenance()
//loadMockPassengers()
//loadMockCrew()
//IO.displayTable(getAllAirports())
//IO.displayTable(getAllCrew())
//IO.displayTable(getAllPassengers())
//IO.displayTable(getAllAircrafts())
