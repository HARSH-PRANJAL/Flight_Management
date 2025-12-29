import Foundation

func initiateUserRegistration() throws -> Int {
    let userName = IO.readString(prompt: "Enter user name : ", terminator: " ")
    let password = IO.readString(prompt: "Enter password : ", terminator: " ")
    let dob = IO.readDate(prompt: "Enter date of birth : ", terminator: " ")
    let gender = Gender.allCases[IO.readEnumOption(enumType: Gender.self) - 1]

    let email: String

    while true {
        let rawEmail = IO.readString(
            prompt: "Enter user email : ",
            terminator: " "
        )

        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.com$"#

        if rawEmail.range(of: pattern, options: .regularExpression) != nil {
            email = rawEmail
        } else {
            print("Wrong email format ‼️\nTry again. \n")
            continue
        }

        break
    }

    let phone = IO.readString(
        prompt: "Enter user phone number : ",
        terminator: " "
    )

    let crewType: CrewType?
    let address: String?

    var yesNo = IO.readString(
        prompt: "Do you want to provide crew type : (y/n)",
        terminator: " "
    ).lowercased()
    if yesNo == "y" {
        crewType =
            CrewType.allCases[IO.readEnumOption(enumType: CrewType.self) - 1]
        address = IO.readString(prompt: "Enter address : ", terminator: " ")
    } else {
        crewType = nil
        
        yesNo = IO.readString(
            prompt: "Do you want to provide address : (y/n)",
            terminator: " "
        ).lowercased()
        address =
            yesNo == "y"
            ? IO.readString(prompt: "Enter address : ", terminator: " ") : nil
    }
    
    guard let newUserId = registerUser(dob: dob, gender: gender, name: userName, email: email, password: password, phone: phone, address: address, crewType: crewType) else {
        throw UserError.registrationFailed
    }
    
    return newUserId
}
