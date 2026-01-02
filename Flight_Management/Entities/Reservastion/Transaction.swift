import Foundation

struct Transaction {
    static var nextId: Int = 1
    let id: Int = {
        let currentId = Transaction.nextId
        Transaction.nextId += 1
        return currentId
    }()

    let date: Date = Date()
    let amount: Double
    let type: TransactionType
    let userId: Int
    var refundToId: Int?

    var getInitialTransactionId: Int? {
        if refundToId != nil {
            return refundToId
        } else {
            return nil
        }
    }
}
