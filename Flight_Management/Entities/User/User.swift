import Foundation

protocol User {
    var id: Int { get }
    var createdAt: Date { get }
    var dob: Date { get }
    var gender: Gender { get }
    var name: String { get set }
    var updatedAt: Date { get set }
    var idProof: String? { get set }
    var idProofType: IdProofType? { get set }
    var address: String? { get set }
    var phone: String? { get set }
    var email: String { get set }
    var password: String { get set }

    func updateUser(
        name: String?,
        idProof: String?,
        idProofType: IdProofType?,
        address: String?,
        phone: String?,
        email: String?,
        password: String?
    ) -> Bool

    func verifyPassword(_ password: String) -> Bool
}

extension User {

    mutating func updateUser(
        name: String? = nil,
        idProof: String? = nil,
        idProofType: IdProofType? = nil,
        address: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        password: String? = nil
    ) -> Bool {
        if let name = name {
            self.name = name
        }
        if let idProof = idProof {
            self.idProof = idProof
        }
        if let idProofType = idProofType {
            self.idProofType = idProofType
        }
        if let address = address {
            self.address = address
        }
        if let phone = phone {
            self.phone = phone
        }
        if let email = email {
            self.email = email
        }
        if let password = password {
            self.password = password
        }

        self.updatedAt = Date()
        return true
    }

    func verifyPassword(_ password: String) -> Bool {
        return self.password == String(password.hashValue)
    }

}
