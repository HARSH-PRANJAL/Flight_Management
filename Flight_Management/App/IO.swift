import Foundation

struct IO {
    static func readInt(prompt: String, terminator: String = " ") -> Int {
        print(prompt, terminator: terminator)

        while true {
            if let input = readLine(), let number = Int(input) {
                return number
            } else {
                print(
                    "\nYour input is not a number provide correct input !!!!\n"
                )
            }
        }
    }

    static func readDouble(prompt: String, terminator: String = " ") -> Double {
        print(prompt, terminator: terminator)

        while true {
            if let input = readLine(), let number = Double(input) {
                return number
            } else {
                print(
                    "\nYour input is not a number provide correct input !!!!\n"
                )
            }
        }
    }

    static func readString(prompt: String, terminator: String = " ") -> String {
        print(prompt, terminator: terminator)

        while true {
            if let input = readLine() {
                return input
            } else {
                print(
                    "\nSomething wrong with input please try again !!!!\n"
                )
            }
        }
    }

    static func readDate(prompt: String, terminator: String = " ") -> Date {
        print(prompt, terminator: terminator)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "hi_IN")

        var input = readString(prompt: "(dd-MM-yyyy)", terminator: " ")

        while true {
            if let date = dateFormatter.date(from: input) {
                return date
            } else {
                input = readString(
                    prompt: "Please enter date in dd-MM-yyyy format : ",
                    terminator: ""
                )
            }
        }
    }

    static func readDateTime(prompt: String, terminator: String = " ") -> Date {
        print(prompt, terminator: terminator)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "hi_IN")

        var input = readString(prompt: "(dd-MM-yyyy HH:mm)", terminator: " ")

        while true {
            if let date = dateFormatter.date(from: input) {
                return date
            } else {
                input = readString(
                    prompt: "Please enter date in dd-MM-yyyy HH:mm format : ",
                    terminator: ""
                )
            }
        }
    }

    static func readOptionNumber(
        size: Int,
        msg: String = "Enter your choice : "
    ) -> Int {
        var choice: Int

        while true {
            choice = IO.readInt(prompt: msg, terminator: " ")

            if choice <= 0 || choice > size {
                print(" Wrong choice ‼️ ")
                print(" Try again \n")
            } else {
                return choice
            }
        }
    }

    static func readOptional<T>(msg: String, readValue: () -> T) -> T? {
        let answer = IO.readString(
            prompt: "\(msg) : (y/n)",
            terminator: " "
        ).lowercased()

        return answer == "y" ? readValue() : nil
    }

    static func displayEnumOptions<T: CaseIterable & CustomStringConvertible>(
        enumType: T.Type,
        msg: String = ""
    ) {
        print("\n\(msg)")

        let menu = enumType.allCases

        for (i, option) in menu.enumerated() {
            print("\(i+1) \(option.description)")
        }
    }

    static func displayDateTime(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        
        print(formatter.string(from: date), terminator: "")
    }
}
