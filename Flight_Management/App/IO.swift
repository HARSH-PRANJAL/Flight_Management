struct IO {
    static func readInt() -> Int {

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

    static func readDouble() -> Double {

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
}
