import Foundation

func readCorrectDateTime(
    prompt: String,
    failMsg: String,
    dateFormat: String = "dd-MM-yyyy HH:mm",
    lowerLimit: Date? = nil,
    upperLimit: Date? = nil
) -> Date {
    while true {
        let rawDate = IO.readDate(
            dateFormat: dateFormat,
            prompt: prompt
        )

        var result: Bool = true
        if let lower = lowerLimit, rawDate < lower {
            result = false
        }
        if let upper = upperLimit, rawDate > upper {
            result = false
        }

        if !result {
            print(failMsg)
        } else {
            return rawDate
        }
    }
}

func formatDateTime(_ date: Date, format: String = "dd-MM-yyyy HH:mm") -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter.string(from: date)
}

func readName() -> String {
    while true {
        let rawName = IO.readString(prompt: "Enter name : ")

        if rawName.isEmpty || !rawName.allSatisfy(\.isLetter) {
            print("Please enter a valid name.")
            continue
        } else {
            return rawName
        }
    }
}

func readPhoneNumber() -> String {
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

func readEmail() -> String {
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

func readAlphaNumericString(prompt: String, failMsg: String) -> String {
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
