import Foundation

func initiateUserRegistration(_ isPassenger: Bool = false) throws -> Int {
    let userName = readName()
    let password = IO.readString(prompt: "Enter password : ")
    let phone = readPhoneNumber()
    let email: String = readEmail()
    let dob = try checkDateTime(
        dateTime: IO.readDate(dateFormat: "dd-MM-yyyy", prompt: "Enter DOB : "),
        lowerLimit: Calendar.current.date(
            byAdding: .year,
            value: -90,
            to: Date()
        ),
        upperLimit: Calendar.current.date(
            byAdding: .year,
            value: -10,
            to: Date()
        )
    )

    IO.displayOptions(options: Gender.allCases, msg: "Select gender")
    let gender = Gender.allCases[
        IO.readInt(size: Gender.allCases.count) - 1
    ]

    let crewType: CrewType?
    var address: String? = nil

    if isPassenger {
        crewType = nil
        let ops = IO.readString(
            prompt: "Do you want to provide address ? (y/n) : ",
            options: ["y", "n"]
        )
        if ops == "y" {
            address = readAlphaNumericString("Enter address : ", "Please provide correct address.")
        }
    } else {
        let crews = CrewType.allCases
        IO.displayOptions(options: crews, msg: "Select crew type")

        let crewOption = IO.readInt(size: crews.count)
        crewType = crews[crewOption - 1]
        address = readAlphaNumericString("Enter address : ", "Please provide correct address.")
    }

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
    let economySeat = IO.readInt(prompt: "Enter number of economy seats : ")
    let businessSeat = IO.readInt(prompt: "Enter number of business seats : ")
    let firstClassSeat = IO.readInt(
        prompt: "Enter number of first class seats : "
    )
    let fuelCapacity = IO.readDouble(prompt: "Enter total fuel capacity : ")

    return registerAircraft(
        model: model,
        manufacturer: manufacturer,
        economySeat: economySeat,
        businessSeat: businessSeat,
        firstClassSeat: firstClassSeat,
        fuelCapacity: fuelCapacity
    )
}

func initiateRouteRegistration() throws -> Bool {
    let sourceId = IO.readInt(prompt: "Enter source airport id : ")
    let destinationId = IO.readInt(prompt: "Enter destination airport id : ")

    if !isAirportExist(id: sourceId)
        || !isAirportExist(id: destinationId)
    {
        throw DataError.dataNotFound(msg: "Airport dose not exist.")
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

    if !isAircraftExist(id: aircraftId) {
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
        dateTime: IO.readDate(
            dateFormat: "dd-MM-yyyy HH:mm",
            prompt: "Enter departure time : "
        ),
        lowerLimit: earliestAllowedDeparture,
        upperLimit: latestAllowedDeparture
    )

    if let newId = registerFlight(
        aircraftId: aircraftId,
        scheduledDeparture: departureTime,
        route: route
    ) {
        return newId
    } else {
        throw DataError.invalidData(msg: "Aircraft is not available.")
    }
}

func initiateFlightMaintenanceLogRegistration() throws -> Int {
    let aircraftId = IO.readInt(prompt: "Enter aircraft id : ")

    if !isAircraftExist(id: aircraftId) {
        throw DataError.dataNotFound(msg: "Aircraft dose not exist.")
    }

    let scheduledDate: Date = try checkDateTime(
        dateTime: IO.readDate(
            dateFormat: "dd-MM-yyyy HH:mm",
            prompt: "Enter scheduled date : "
        ),
        lowerLimit: Date()
    )
    let expectedCompletionDate: Date = try checkDateTime(
        dateTime: IO.readDate(
            dateFormat: "dd-MM-yyyy HH:mm",
            prompt: "Enter expected completion date : "
        ),
        lowerLimit: scheduledDate
    )

    if let newLogID = registerMaintenanceLog(
        aircraftId: aircraftId,
        scheduledDate: scheduledDate,
        expectedCompletionDate: expectedCompletionDate
    ) {
        return newLogID
    } else {
        throw DataError.invalidData(msg: "Aircraft is not available.")
    }
}

func initiateLeaveApplication(for crew: Crew) throws -> Bool {
    let reason = IO.readString(prompt: "Enter reason for leave : ")

    let today = Date()
    let maxDate = Calendar.current.date(byAdding: .day, value: 15, to: today)!

    let fromDate = try checkDateTime(
        dateTime: IO.readDate(
            dateFormat: "dd-MM-yyyy",
            prompt: "From : "
        ),
        lowerLimit: today,
        upperLimit: maxDate
    )

    let toDate = try checkDateTime(
        dateTime: IO.readDate(
            dateFormat: "dd-MM-yyyy",
            prompt: "To : "
        ),
        lowerLimit: fromDate,
        upperLimit: maxDate
    )

    return crew.applyLeave(reason: reason, from: fromDate, to: toDate)
}
