func findAirportById(id: Int) -> Airport? {
    return airports[id]
}

func isAirportExist(withId id: Int) -> Bool {
    return airports.keys.contains(id)
}

func registerAirport(
    airportCode: String,
    name: String,
    city: String,
    country: String
) -> Int {

    let newAirport = Airport(
        airportCode: airportCode,
        name: name,
        city: city,
        country: country
    )

    airports[newAirport.id] = newAirport
    return newAirport.id
}
