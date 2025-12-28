import Foundation

func findUserById(by id: Int) -> User? {
    if let passenger = passengers[id] {
        return passenger
    }
    if let crew = crews[id] {
        return crew
    }

    return nil
}

func registerUser(
    dob: Date,
    gender: Gender,
    name: String,
    email: String,
    password: String,
    phone: String,
    address: String?,
    idProof: String? = nil,
    idProofType: IdProofType? = nil,
    crewType: CrewType? = nil
) -> Int? {
    let newUser: User

    if let crewType = crewType {
        guard let crewAddress = address else {
            return nil
        }

        newUser = Crew(
            dob: dob,
            gender: gender,
            name: name,
            email: email,
            password: password,
            phone: phone,
            address: crewAddress,
            crewType: crewType
        )
        
        if let crew = newUser as? Crew {
            crews[crew.id] = crew
        } else {
            return nil
        }
        
    } else {
        
        newUser = Passenger(
            dob: dob,
            gender: gender,
            name: name,
            email: email,
            password: password,
            phone: phone,
            idProof: idProof,
            idProofType: idProofType,
            address: address
        )
        
        if let passenger = newUser as? Passenger {
            passengers[passenger.id] = passenger
        } else {
            return nil
        }
    }
    
    return newUser.id
}

func setCrewPerHourSalary(
    for crewId: Int,
    flightSalary: Double,
    groundSalary: Double
) -> Bool {
    guard var crew = crews[crewId] else {
        return false
    }

    crew.inAirPayRatePerHour = flightSalary
    crew.groundDutyPayRatePerHour = groundSalary

    crews[crewId] = crew
    return true
}
