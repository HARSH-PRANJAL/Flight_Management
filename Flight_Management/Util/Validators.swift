import Foundation

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

func readCorrectPhone() -> String {
    while true {
        let rawPhone = IO.readString(
            prompt: "Enter phone number : "
        )
        
        let pattern = #"^[6-9]\d{9}$"#
        
        if rawPhone.range(of: pattern, options: .regularExpression) != nil {
            return rawPhone
        } else {
            print("Please enter valid phone number...")
        }
    }
}

func readNonIntString(prompt: String) -> String {
    while true {
        let rawAddress = IO.readString(prompt: prompt)
        
        if !rawAddress.isEmpty || !rawAddress.allSatisfy(\.isNumber) {
            return rawAddress
        } else {
            print("Please enter valid value...")
        }
    }
}

func checkDateTime(
    dateTime: Date,
    lowerLimit: Date? = nil,
    upperLimit: Date? = nil
) throws(DataError) -> Date {

    let calendar = Calendar.current

    if let lower = lowerLimit, dateTime < lower {
        let nextValidDate = calendar.startOfDay(for: lower)

        throw DataError.invalidData(
            msg: "Invalid date. Please enter a date after \(formatDateTime(nextValidDate))."
        )
    }

    if let upper = upperLimit, dateTime > upper {
        let lastValidDate = calendar.startOfDay(for: upper)

        throw DataError.invalidData(
            msg: "Invalid date. Please enter a date1 before \(formatDateTime(lastValidDate))."
        )
    }

    return dateTime
}

func formatDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy HH:mm"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.string(from: date)
}
