import Foundation

protocol User: CustomStringConvertible, TableRepresentable {
    var id: Int { get }
    var createdAt: Date { get }
    var dob: Date { get }
    var gender: Gender { get }
    var name: String { get set }
    var updatedAt: Date { get set }
    var idProof: String? { get set }
    var idProofType: IdProofType? { get set }
    var address: String? { get set }
    var phone: String { get set }
    var email: String { get set }
    var password: String { get set }

    func verifyPassword(_ password: String) -> Bool
    
    var description: String { get }
}

extension User {

    func verifyPassword(_ password: String) -> Bool {
        return self.password == passwordHash(password: password)
    }

}
