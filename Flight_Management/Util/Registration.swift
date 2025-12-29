import Foundation

func initiateUserRegistration() throws(UserError) -> Int {
    let userName = IO.readString(prompt: "Enter user name : ", terminator: " ")
    let password = IO.readString(prompt: "Enter password : ", terminator: " ")
    let phone = IO.readString(
        prompt: "Enter phone number : ",
        terminator: " "
    )

    let email: String = readCorrectEmail()
    let dob = try readCorrectDOB()

    IO.displayEnumOptions(enumType: Gender.self, msg: "Select gender")
    let gender = Gender.allCases[
        IO.readEnumOption(enumSize: Gender.allCases.count) - 1
    ]

    let crewOption: Int? = IO.readOptional(
        msg: "Do you want to provide crew type",
        readValue: {
            IO.displayEnumOptions(
                enumType: CrewType.self,
                msg: "Select crew type"
            )
            return IO.readEnumOption(enumSize: CrewType.allCases.count)
        }
    )
    let crewType: CrewType? =
        crewOption != nil ? CrewType.allCases[crewOption! - 1] : nil

    let readAddress = {
        IO.readString(prompt: "Enter address : ", terminator: " ")
    }
    let address: String? =
        crewType != nil
        ? readAddress()
        : IO.readOptional(
            msg: "Do you want to provide address",
            readValue: readAddress
        )

    guard
        let newUserId = registerUser(
            dob: dob,
            gender: gender,
            name: userName,
            email: email,
            password: password,
            phone: phone,
            address: address,
            crewType: crewType
        )
    else {
        throw UserError.registrationFailed
    }

    return newUserId
}

func readCorrectEmail() -> String {
    while true {
        let rawEmail = IO.readString(
            prompt: "Enter email : ",
            terminator: " "
        )

        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.com$"#

        if rawEmail.range(of: pattern, options: .regularExpression) != nil {
            return rawEmail
        } else {
            print("\nWrong email format ‼️\nTry again. \n")
            continue
        }
    }
}

func readCorrectDOB() throws(UserError) -> Date {
    let dob = IO.readDate(prompt: "Enter date of birth : ", terminator: " ")
    let upperLimit: Date = Calendar.current.date(
        byAdding: .year,
        value: -10,
        to: Date()
    )!

    if dob >= upperLimit {
        print("User should be older then 10years.")
        throw UserError.dobBelowMinimum
    }

    return dob
}

func initiateAirportRegistration() {

}

func initiateAircraftRegistration() -> Int {
    let model = IO.readString(prompt: "Enter aircraft model : ")
    let manufacturer = IO.readString(prompt: "Enter manufacturer name : ")
    let seatingCapacity = IO.readInt(prompt: "Enter total number of seats : ")
    let fuelCapacity = IO.readDouble(prompt: "Enter total fuel capacity : ")

    let aircraftRepo = DefaultAircraftRepo()

    return aircraftRepo.registerAircraft(
        model: model,
        manufacturer: manufacturer,
        seatingCapacity: seatingCapacity,
        fuelCapacity: fuelCapacity
    )
}
