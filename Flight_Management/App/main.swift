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
var leaveRequests: [Int: String] = [:]
var bookings: [Int: Booking] = [:]
var transactions: [Int: Transaction] = [:]

func main() {
    while true {
        let menu = MainMenu.allCases

        IO.displayOptions(
            options: menu,
            msg:
                """
                ===============================
                           Main Menu
                ===============================
                """
        )

        let choice = IO.readInt(size: menu.count)
        let option = menu[choice - 1]

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

                    crewMenu()
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

        case .passengerLogin:
            let userID = IO.readInt(prompt: "Enter your ID : ")
            let password = IO.readString(prompt: "Enter your password : ")

            do {
                if try authenticateUser(userId: userID, password: password) {
                    authenticatedUser = passengers[userID]!

                    passengerMenu()
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

        case .registerCrew:
            do {
                let newId = try initiateUserRegistration()
                print("\nCrew registered with id : \(newId) ✅")
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }
            continue

        case .registerPassenger:
            do {
                let newId = try initiateUserRegistration(true)
                print("\nPassenger registered with id : \(newId) ✅")
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) ‼️\n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. ‼️\n"
                )
            }
            continue
        }
    }
}

loadMockAirports()
loadMockAircrafts()
loadMockRoutes()
loadMockMaintenance()
loadMockPassengers()
loadMockCrew()
loadMockFlights()
main()
