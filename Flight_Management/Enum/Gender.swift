import Foundation

enum Gender: String, CaseIterable, CustomStringConvertible {
    case male
    case female
    case other
    
    var description: String {
        rawValue.capitalized
    }
}
