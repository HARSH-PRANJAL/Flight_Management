import Foundation

func checkDateTime(
    dateTime: Date,
    lowerLimit: Date? = nil,
    upperLimit: Date? = nil
) throws(DataError) -> Date {

    let calendar = Calendar.current

    if let lower = lowerLimit, dateTime < lower {
        let nextValidDate = calendar.startOfDay(for: lower)

        throw DataError.invalidData(
            msg: "Please enter a date after \(formatDateTime(nextValidDate, format: "dd-MM-yyyy"))."
        )
    }

    if let upper = upperLimit, dateTime > upper {
        let lastValidDate = calendar.startOfDay(for: upper)

        throw DataError.invalidData(
            msg: "Please enter a date before \(formatDateTime(lastValidDate, format: "dd-MM-yyyy"))."
        )
    }

    return dateTime
}

func formatDateTime(_ date: Date, format: String = "dd-MM-yyyy HH:mm") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.string(from: date)
}

let readName = {
while true {
    let rawName = IO.readString(prompt: "Enter name : ")
    
    if rawName.isEmpty || !rawName.allSatisfy(\.isLetter) {
        print("Please enter a valid name.")
        continue
    } else {
        return rawName
    }}
}

let readPhoneNumber = {
    while true {
        let rawPhone = IO.readString(
            prompt: "Enter phone number : "
        )
        
        let pattern = #"^[6-9]\d{9}$"#
        
        if rawPhone.range(of: pattern, options: .regularExpression) != nil {
            return rawPhone
        } else {
            print("Please enter valid phone number.")
        }
    }
}

let readEmail = {
    while true {
        let rawEmail = IO.readString(
            prompt: "Enter email : "
        )

        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.com$"#
        
        if rawEmail.range(of: pattern, options: .regularExpression) != nil {
            return rawEmail
        } else {
            print("Please enter valid email.")
            continue
        }
    }
}

let readAlphaNumericString = { prompt, failMsg in
    while true {
        let rawValue = IO.readString(prompt: prompt, failMsg: failMsg)
        if !rawValue.isEmpty && rawValue.allSatisfy(\.isNumber) {
            print(failMsg)
            continue
        } else {
            return rawValue
        }
    }
}
