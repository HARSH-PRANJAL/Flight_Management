struct Airport: CustomStringConvertible {
    static var nextId: Int = 1
    let id: Int
    let airportCode: String
    let name: String
    let city: String
    let country: String
    
    init(airportCode: String, name: String, city: String, country: String) {
        self.id = Airport.nextId
        Airport.nextId += 1
        self.airportCode = airportCode
        self.name = name
        self.city = city
        self.country = country
    }
    
    var description: String {
        return "Airport id: \(id), name: \(name)"
    }
}
