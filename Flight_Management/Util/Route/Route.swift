import Foundation

struct Route: TableRepresentable {
    let airportPath: [Int]
    let totalDuration: Double
    let totalFare: Double

    static var tableHeaders: [String] {
        ["Route", "Total Duration", "Total Fare"]
    }

    var tableRow: [String] {
        [
            pathDescription,
            String(format: "%.2f", totalDuration),
            String(totalFare.formatted(.currency(code: "INR"))),
        ]
    }

    var pathDescription: String {
        var result: String = ""

        for id in airportPath {
            if let airport = findAirportById(id: id) {
                result.append(airport.airportCode)
                result.append(" -> ")
            }
        }

        result.removeLast(4)
        return result
    }

    var description: String {
        var result = pathDescription
        result.append("\n total duration : \(totalDuration)")
        return result
    }
}
