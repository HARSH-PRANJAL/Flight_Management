import Foundation

// store user role after auth for role based menu options
var userRole: CrewType?
var authenticatedUser: User?

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
            let userID = IO.readInt(
                prompt: "Enter your ID : ",
                failMsg: "Please enter a valid user id."
            )
            let password = IO.readString(prompt: "Enter your password : ")

            do {
                if try authenticateUser(
                    userId: userID,
                    password: password,
                    crew: true
                ) {
                    crewMenu()
                }
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) \n")
            } catch let error as AuthError {
                print(
                    "\n🚨 Error: \(error.description) wrong credentials. Try again.\n"
                )
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later.\n"
                )
            }

        case .passengerLogin:
            let userID = IO.readInt(
                prompt: "Enter your ID : ",
                failMsg: "Please enter a valid user id."
            )
            let password = IO.readString(prompt: "Enter your password : ")

            do {
                if try authenticateUser(userId: userID, password: password) {
                    passengerMenu()
                }
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description)\n")
            } catch let error as AuthError {
                print(
                    "\n🚨 Error: \(error.description), wrong credentials. Try again.\n"
                )
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later.\n"
                )
            }

        case .registerCrew:
            do {
                let newId = try initiateUserRegistration()
                print("\nCrew registered with id : \(newId) ✅")
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) \n")
            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }

        case .registerPassenger:
            do {
                let newId = try initiateUserRegistration(true)
                print("\nPassenger registered with id : \(newId) ✅")
            } catch let error as UserError {
                print("\n🚨 Error: \(error.description) \n")
            } catch let error as DataError {
                print("\n🚨 Error: \(error) \n")
            } catch {
                print(
                    "\n🚨 An unexpected error occurred. Please try again later. \n"
                )
            }

        case .exit:
            authenticatedUser = nil
            userRole = nil
            return

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
