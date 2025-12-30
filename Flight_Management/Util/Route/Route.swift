struct Route {
    let airportPath: [Int]
    let totalDuration: Double
    let totalFare: Double
    
    var description: String {
        var result: String = ""
        
        for id in airportPath {
            if let airport = findAirportById(id: id) {
                result.append(airport.airportCode)
                result.append(" -> ")
            }
        }
        
        result.append("\n total duration : \(totalDuration)")
        return result
    }
}
