import Foundation

func initiateUserRegistration() throws(UserError) -> Int {
    let userName = IO.readString(prompt: "Enter user name : ")
    let password = IO.readString(prompt: "Enter password : ")
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
            prompt: "Enter email : "
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
    let dob = IO.readDate(prompt: "Enter date of birth : ")
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

func initiateAirportRegistration() -> Int {
    let airportCode = IO.readString(prompt: "Enter airport code : ")
    let name = IO.readString(prompt: "Enter airport name : ")
    let city = IO.readString(prompt: "Enter city name : ")
    let country = IO.readString(prompt: "Enter country name : ")

    return registerAirport(
        airportCode: airportCode,
        name: name,
        city: city,
        country: country
    )
}

func initiateAircraftRegistration() -> Int {
    let model = IO.readString(prompt: "Enter aircraft model : ")
    let manufacturer = IO.readString(prompt: "Enter manufacturer name : ")
    let seatingCapacity = IO.readInt(prompt: "Enter total number of seats : ")
    let fuelCapacity = IO.readDouble(prompt: "Enter total fuel capacity : ")

    return registerAircraft(
        model: model,
        manufacturer: manufacturer,
        seatingCapacity: seatingCapacity,
        fuelCapacity: fuelCapacity
    )
}

func initiateRouteRegistration() throws -> Bool {
    let sourceId = IO.readInt(prompt: "Enter source airport id : ")
    let destinationId = IO.readInt(prompt: "Enter destination airport id : ")

    if !isAirportExist(withId: sourceId)
        || !isAircraftExist(witId: destinationId)
    {
        throw DataError.dataNotFound
    }

    let duration: Double = IO.readDouble(
        prompt: "Enter estimated flight duration in hours : "
    )
    let basePrice: Double = IO.readDouble(prompt: "Enter base fare price : ")

    let route = AirportRouteGraph()
    route.addRoute(
        from: sourceId,
        to: destinationId,
        fare: basePrice,
        durationHours: duration
    )

    return true
}

func initiateFlightRegistration(route: Route) throws -> Int {
    let aircraftId = IO.readInt(prompt: "Enter aircraft id for this flight : ")

    if !isAircraftExist(witId: aircraftId) {
        throw DataError.dataNotFound(msg: "Aircraft dose not exist.")
    }

    let earliestAllowedDeparture: Date? = Calendar.current.date(
        byAdding: .day,
        value: 1,
        to: Date()
    )
    let latestAllowedDeparture: Date? = Calendar.current.date(
        byAdding: .day,
        value: 30,
        to: Date()
    )
    let departureTime: Date = try checkDateTime(
        dateTime: IO.readDateTime(prompt: "Enter departure time : "),
        lowerLimit: earliestAllowedDeparture,
        upperLimit: latestAllowedDeparture
    )
    
    return registerFlight(airCraftId: aircraftId, scheduledDeparture: departureTime, route: route)
}
