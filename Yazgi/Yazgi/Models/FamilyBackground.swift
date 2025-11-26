import Foundation

enum ParentRole: String, Codable {
    case mother, father, unknown
}

enum IncomeLevel: String, Codable {
    case none, low, medium, high, veryHigh
}

enum DeathCause: String, Codable {
    case illness, accident, war, unknown, suicide, naturalCauses
}

struct Parent: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String?
    var role: ParentRole
    var gender: String?
    var occupation: String?
    var incomeLevel: IncomeLevel
    var isAlive: Bool
    var deathCause: DeathCause?
    var isKnown: Bool  // oyuncu bu ebeveyni tanıyor mu?
}

enum MaritalStatus: String, Codable {
    case married
    case divorced
    case neverMarried
    case singleParent
    case unknown
}

enum CustodyDecision: String, Codable {
    case mother
    case father
    case shared
    case courtDecided
    case childChose
    case unknown
}

struct FamilyBackground: Codable {
    var parents: [Parent]  // 0, 1 ya da 2 olabilir
    var maritalStatus: MaritalStatus
    var hasPrenup: Bool?
    var isAdopted: Bool
    var custody: CustodyDecision?
    
    var householdIncomeLevel: IncomeLevel {
        // Ortak gelir hesaplama (varsa)
        let knownParents = parents.filter { $0.isKnown }
        let incomeScores = knownParents.map {
            switch $0.incomeLevel {
                case .none: return 0
                case .low: return 1
                case .medium: return 2
                case .high: return 3
                case .veryHigh: return 4
            }
        }

        let avgScore = incomeScores.isEmpty ? 0 : incomeScores.reduce(0, +) / incomeScores.count

        switch avgScore {
            case 0: return .none
            case 1: return .low
            case 2: return .medium
            case 3: return .high
            default: return .veryHigh
        }
    }
}
