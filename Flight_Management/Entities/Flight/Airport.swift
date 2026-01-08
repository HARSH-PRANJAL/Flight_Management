struct Airport: CustomStringConvertible, TableRepresentable {
    static var nextId: Int = 1
    let id: Int = {
        let currntId = Airport.nextId
        Airport.nextId += 1
        return currntId
    }()
    
    let airportCode: String
    let name: String
    let city: String
    let country: String
    
    var description: String {
        return "Airport id: \(id), name: \(name)"
    }
    
    static var tableHeaders: [String] {
        ["ID", "Code", "Name", "City", "Country"]
    }

    var tableRow: [String] {
        [
            String(id),
            airportCode,
            name,
            city,
            country
        ]
    }
}
