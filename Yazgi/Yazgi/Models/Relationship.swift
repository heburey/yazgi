import Foundation

struct Relationship: Codable {
    // MARK: - Basic Information
    var id: UUID = UUID()
    var type: RelationshipType
    var status: RelationshipStatus
    var startDate: Date
    var endDate: Date?
    
    // MARK: - Character Information
    var characterName: String
    var characterAge: Int
    var characterOccupation: String?
    var characterTraits: [String]
    
    // MARK: - Relationship Metrics
    var intimacy: Int // 0-100
    var trust: Int // 0-100
    var respect: Int // 0-100
    var compatibility: Int // 0-100
    var tension: Int // 0-100
    var influence: Int // 0-100
    
    // MARK: - History & Dynamics
    var memories: [Memory]
    var sharedExperiences: [SharedExperience]
    var milestones: [RelationshipMilestone]
    var conflicts: [Conflict]
    var effects: [RelationshipEffect]
    
    // MARK: - Communication & Interaction
    var communicationStyle: CommunicationStyle
    var interactionFrequency: InteractionFrequency
    var lastInteraction: Date
    var nextPlannedInteraction: Date?
    
    // MARK: - Preferences & Boundaries
    var sharedInterests: [String]
    var boundaries: [Boundary]
    var expectations: [String]
    var dealBreakers: [String]
}

enum ExperienceType: String, Codable {
    case social = "Sosyal"
    case adventure = "Macera"
    case celebration = "Kutlama"
    case travel = "Seyahat"
    case learning = "Öğrenme"
    case support = "Destek"
    case conflict = "Çatışma"
    case milestone = "Dönüm Noktası"
}

struct RelationshipMilestone: Codable {
    var title: String
    var description: String
    var date: Date
    var type: MilestoneType
    var significance: Int // 1-10
    var effects: [RelationshipEffect]
    var memories: [Memory]
}

enum MilestoneType: String, Codable {
    case firstMeeting = "İlk Tanışma"
    case commitment = "Bağlılık"
    case trust = "Güven"
    case conflict = "Çatışma"
    case reconciliation = "Barışma"
    case achievement = "Başarı"
    case loss = "Kayıp"
    case transformation = "Dönüşüm"
}

struct Conflict: Codable {
    var title: String
    var description: String
    var date: Date
    var type: ConflictType
    var severity: Int // 1-10
    var resolution: String?
    var effects: [RelationshipEffect]
    var lessons: [String]
}

enum ConflictType: String, Codable {
    case misunderstanding = "Yanlış Anlama"
    case values = "Değer Çatışması"
    case boundaries = "Sınır İhlali"
    case trust = "Güven Sorunu"
    case communication = "İletişim Sorunu"
    case expectations = "Beklenti Uyuşmazlığı"
    case external = "Dış Etkenler"
    case personality = "Kişilik Çatışması"
}

enum CommunicationStyle: String, Codable {
    case open = "Açık"
    case reserved = "Çekingen"
    case direct = "Direkt"
    case indirect = "Dolaylı"
    case emotional = "Duygusal"
    case rational = "Mantıksal"
    case supportive = "Destekleyici"
    case critical = "Eleştirel"
}

enum InteractionFrequency: String, Codable {
    case daily = "Günlük"
    case weekly = "Haftalık"
    case monthly = "Aylık"
    case quarterly = "Üç Aylık"
    case yearly = "Yıllık"
    case rarely = "Nadiren"
    case never = "Hiç"
}

struct Boundary: Codable {
    var type: BoundaryType
    var description: String
    var importance: Int // 1-10
    var consequences: [String]
    var isRespected: Bool
}

enum BoundaryType: String, Codable {
    case physical = "Fiziksel"
    case emotional = "Duygusal"
    case mental = "Zihinsel"
    case social = "Sosyal"
    case financial = "Finansal"
    case digital = "Dijital"
    case time = "Zaman"
    case space = "Alan"
}

// MARK: - Preview Helper
extension Relationship {
    static var preview: Relationship {
        Relationship(
            type: RelationshipType.friend,
            status: RelationshipStatus.friend,
            startDate: Date(),
            characterName: "Ahmet Yılmaz",
            characterAge: 25,
            characterOccupation: "Öğretmen",
            characterTraits: ["Anlayışlı", "Yardımsever", "Neşeli"],
            intimacy: 75,
            trust: 80,
            respect: 85,
            compatibility: 70,
            tension: 20,
            influence: 60,
            memories: [],
            sharedExperiences: [],
            milestones: [],
            conflicts: [],
            effects: [],
            communicationStyle: CommunicationStyle.open,
            interactionFrequency: InteractionFrequency.weekly,
            lastInteraction: Date(),
            sharedInterests: ["Müzik", "Spor", "Seyahat"],
            boundaries: [],
            expectations: ["Dürüstlük", "Saygı", "Destek"],
            dealBreakers: ["Güvensizlik", "Saygısızlık"]
        )
    }
} 