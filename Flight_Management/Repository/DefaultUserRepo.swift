import Foundation

func findCrewById(id: Int) -> Crew? {
    return crews[id]
}

func findPassengerById(id: Int) -> Passenger? {
    return passengers[id]
}

func getAllCrew() -> [Crew] {
    return Array(crews.values).sorted(by: { a, b in a.id < b.id
    })
}

func getAllPassengers() -> [Passenger] {
    return Array(passengers.values).sorted(by: { a, b in a.id < b.id
    })
}

func registerUser(
    dob: Date,
    gender: Gender,
    name: String,
    email: String,
    password: String,
    phone: String,
    address: String?,
    crewType: CrewType?
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

func registerLeaveRequest(leave: (Int,(String,Date,Date))) -> Bool {
    if leaveRequests.keys.contains(leave.0) {
        return false
    }
    
    leaveRequests[leave.0] = (leave.1.0, leave.1.1, leave.1.2)
    return true
}

func registerResignation(crewId: Int) -> Bool {
    if resignationRequests.contains(crewId) {
        return false
    }
    
    resignationRequests.insert(crewId)
    return true
}
