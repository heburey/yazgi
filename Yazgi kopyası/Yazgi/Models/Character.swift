import Foundation

struct Character: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var health: Int
    var happiness: Int
    var smarts: Int
    var looks: Int
    var intelligence: Int
    var beauty: Int
    var luck: Int
    var aura: Int
    var educationPrestige: Int
    var network: Int
    var reputation: Int
    var incomePower: Int
    var money: Int
    var educationLevel: EducationLevel
    var jobTitle: String?
    var relationshipStatus: RelationshipStatus
    var gender: String
    var country: String
    var sexualOrientation: SexualOrientation
    var careerPath: CareerPath
    var occupation: String?
    var family: FamilyBackground
    
    // BitLife-like additions
    var spouse: Spouse?
    var children: [Child] = []
    var salary: Int = 0
    var isDead: Bool = false
    var deathCause: String?
    var yearOfDeath: Int?
    var criminalRecord: [String] = []
    var achievements: [String] = []
}

enum EducationLevel: String, Codable, CaseIterable {
    case none = "Eğitimsiz"
    case primary = "İlkokul"
    case secondary = "Lise"
    case university = "Üniversite"
    case graduate = "Yüksek Lisans"
}

enum RelationshipStatus: String, Codable, CaseIterable {
    case single = "Bekar"
    case dating = "İlişkide"
    case married = "Evli"
    case situationship = "Belirsiz"
}

enum SexualOrientation: String, Codable {
    case heterosexual = "Heteroseksüel"
    case homosexual = "Homoseksüel"
    case bisexualPan = "Biseksüel/Pan"
    case asexual = "Aseksüel"
    case questioning = "Belirsiz"
}

enum CareerPath: String, Codable, CaseIterable {
    case stem = "STEM"
    case arts = "Sanat"
    case care = "Bakım"
    case business = "İş Dünyası"
    case social = "Sosyal Bilimler"
    case trades = "Zanaat"

    static func random() -> CareerPath {
        CareerPath.allCases.randomElement() ?? .social
    }
}

struct Spouse: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var gender: String
    var occupation: String?
    var relationshipQuality: Int // 0-100
    var yearsTogether: Int = 0
}

struct Child: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var age: Int
    var gender: String
    var relationshipQuality: Int // 0-100
}
