import Foundation

struct IO {
    static func readInt(
        prompt: String,
        terminator: String = " ",
        failMsg: String = "Your input is not a number provide correct input."
    ) -> Int {
        while true {
            print(prompt, terminator: terminator)

            if let input = readLine(), let number = Int(input) {
                return number
            } else {
                print(failMsg)
            }
        }
    }

    static func readInt(
        prompt: String = "Enter your choice : ",
        terminator: String = " ",
        size: Int,
        failMsg: String = "Please enter a valid option."
    ) -> Int {
        var choice: Int

        while true {
            choice = IO.readInt(prompt: prompt, terminator: " ")

            if choice <= 0 || choice > size {
                print(failMsg)
            } else {
                return choice
            }
        }
    }

    static func readDouble(
        prompt: String,
        terminator: String = " ",
        failMsg: String = "Your input is not a number provide correct input."
    ) -> Double {
        while true {
            print(prompt, terminator: terminator)

            if let input = readLine(), let number = Double(input) {
                return (number * 100).rounded() / 100
            } else {
                print(failMsg)
            }
        }
    }

    static func readString(
        prompt: String,
        terminator: String = " ",
        failMsg: String = "Something wrong with input please try again."
    ) -> String {
        while true {
            print(prompt, terminator: terminator)

            if let input = readLine() {
                return input
            } else {
                print(failMsg)
            }
        }
    }

    static func readString(
        prompt: String,
        terminator: String = " ",
        options: [String],
        failMsg: String = "Chose correct option."
    ) -> String {
        var choice = IO.readString(prompt: prompt, terminator: " ").lowercased()

        while !options.contains(choice) {
            print(failMsg)
            choice = IO.readString(prompt: prompt, terminator: " ").lowercased()
        }

        return choice
    }

    static func readDate(
        dateFormat: String,
        prompt: String,
        terminator: String = " "
    ) -> Date {
        print(prompt, terminator: terminator)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        var input = readString(prompt: "(\(dateFormat))", terminator: " ")

        while true {
            if let date = dateFormatter.date(from: input) {
                return date
            } else {
                input = readString(
                    prompt: "Please enter date in \(dateFormat) format : ",
                    terminator: ""
                )
            }
        }
    }

    static func displayOptions<T: CaseIterable & CustomStringConvertible>(
        options: [T],
        msg: String = ""
    ) {
        print("\n\(msg)")

        for (i, option) in options.enumerated() {
            print("\(i+1) \(option.description)")
        }
    }

    static func displayTable(
        heading: String,
        headers: [String],
        rows: [[String]],
        failMsg: String = "No data available."
    ) {
        guard !rows.isEmpty else {
            print(failMsg)
            return
        }

        let allRows = [headers] + rows

        let columnWidths = headers.indices.map { index in
            allRows
                .compactMap { row in
                    index < row.count ? row[index].count : nil
                }
                .max() ?? 0
        }

        let printRow: ([String]) -> Void = { row in
            let padded = headers.indices.map { index in
                let value = index < row.count ? row[index] : ""
                return value.padding(
                    toLength: columnWidths[index],
                    withPad: " ",
                    startingAt: 0
                )
            }
            print(padded.joined(separator: " | "))
        }

        print("\n\t\t\(heading)\n")
        printRow(headers)
        print(
            columnWidths
                .map { String(repeating: "-", count: $0) }
                .joined(separator: "-+-")
        )

        rows.forEach { printRow($0) }
    }
}
