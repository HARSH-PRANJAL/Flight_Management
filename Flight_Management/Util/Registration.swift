import Foundation

func initiateUserRegistration(_ isPassenger: Bool = false) throws -> Int {
    let userName = readName()
    let password = IO.readString(prompt: "Enter password : ")
    let phone = readPhoneNumber()
    let email: String = readEmail()

    let dob: Date = readCorrectDateTime(
        prompt: "Enter DOB : ",
        failMsg: "User should be older then 10 and younger then 90 years.",
        dateFormat: "dd-MM-yyyy",
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
    let readAddress = {
        readAlphaNumericString(
            prompt: "Enter address : ",
            failMsg: "Please provide correct address."
        )
    }

    if isPassenger {
        crewType = nil
        let ops = IO.readString(
            prompt: "Do you want to provide address ? (y/n) : ",
            options: ["y", "n"]
        )
        if ops == "y" {
            address = readAddress()
        }
    } else {
        let crews = CrewType.allCases
        IO.displayOptions(options: crews, msg: "Select crew type")

        let crewOption = IO.readInt(size: crews.count)
        crewType = crews[crewOption - 1]
        address = readAddress()
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

func initiateFlightRegistration(route: Route) throws -> Int? {
    var aircraftId: Int

    while true {
        aircraftId = IO.readInt(prompt: "Enter aircraft id : ")

        if !isAircraftExist(id: aircraftId) {
            print("Aircraft does not exist.")

            let ops = IO.readString(
                prompt: "Do you want to try again ? (y/n) : ",
                options: ["y", "n", "Y", "N"]
            ).lowercased()

            if ops == "y" {
                continue
            } else {
                return nil
            }
        } else {
            break
        }
    }

    guard
        let earliestAllowedDeparture = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: Date()
        )
    else {
        throw DataError.invalidData(
            msg: "Can not calculate date for next flight scheduling."
        )
    }

    guard
        let latestAllowedDeparture = Calendar.current.date(
            byAdding: .day,
            value: 30,
            to: Date()
        )
    else {
        throw DataError.invalidData(
            msg: "Can not calculate date for next flight scheduling."
        )
    }

    let format = "dd-MM-yyyy HH:mm"
    let departureTime = readCorrectDateTime(
        prompt: "Enter departure date : ",
        failMsg:
            "You can only schedule a flight between \(formatDateTime(earliestAllowedDeparture, format: format)) and \(formatDateTime(latestAllowedDeparture, format: format))",
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

    let scheduledDate: Date = readCorrectDateTime(
        prompt: "Enter scheduled date : ",
        failMsg: "You can not schedule maintenance in back date.",
        dateFormat: "dd-MM-yyyy",
        lowerLimit: Date()
    )
    let expectedCompletionDate: Date = readCorrectDateTime(
        prompt: "Enter scheduled date : ",
        failMsg:
            "Expected completion date must be after scheduled date (\(formatDateTime(scheduledDate,format: "dd-MM-yyyy"))).",
        dateFormat: "dd-MM-yyyy",
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

func initiateLeaveApplication(for crew: Crew, maxDays: Int = 15) throws -> Bool
{
    let reason = IO.readString(prompt: "Enter reason for leave : ")

    let today = Date()
    guard
        let maxDate = Calendar.current.date(
            byAdding: .day,
            value: maxDays,
            to: today
        )
    else {
        throw DataError.invalidData(
            msg: "Failed to calculate maximum days of leave."
        )
    }

    let fromDate: Date = readCorrectDateTime(
        prompt: "From : ",
        failMsg:
            "You can only apply for a \(maxDays) days of leave from tomorrow.",
        dateFormat: "dd-MM-yyyy",
        lowerLimit: Date(),
        upperLimit: maxDate
    )
    let toDate: Date = readCorrectDateTime(
        prompt: "To : ",
        failMsg:
            "You can only apply for a \(maxDays) days of leave from tomorrow.",
        dateFormat: "dd-MM-yyyy",
        lowerLimit: fromDate,
        upperLimit: maxDate
    )

    return crew.applyLeave(reason: reason, from: fromDate, to: toDate)
}
