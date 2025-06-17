import Foundation

struct Relationship: Codable {
    // MARK: - Basic Information
    var id: UUID
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
    var effects: [RelationshipEffectModel]
    
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
    
    init(type: RelationshipType, status: RelationshipStatus, startDate: Date, endDate: Date? = nil, characterName: String, characterAge: Int, characterOccupation: String? = nil, characterTraits: [String], intimacy: Int, trust: Int, respect: Int, compatibility: Int, tension: Int, influence: Int, memories: [Memory], sharedExperiences: [SharedExperience], milestones: [RelationshipMilestone], conflicts: [Conflict], effects: [RelationshipEffectModel], communicationStyle: CommunicationStyle, interactionFrequency: InteractionFrequency, lastInteraction: Date, nextPlannedInteraction: Date? = nil, sharedInterests: [String], boundaries: [Boundary], expectations: [String], dealBreakers: [String]) {
        self.id = UUID()
        self.type = type
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.characterName = characterName
        self.characterAge = characterAge
        self.characterOccupation = characterOccupation
        self.characterTraits = characterTraits
        self.intimacy = intimacy
        self.trust = trust
        self.respect = respect
        self.compatibility = compatibility
        self.tension = tension
        self.influence = influence
        self.memories = memories
        self.sharedExperiences = sharedExperiences
        self.milestones = milestones
        self.conflicts = conflicts
        self.effects = effects
        self.communicationStyle = communicationStyle
        self.interactionFrequency = interactionFrequency
        self.lastInteraction = lastInteraction
        self.nextPlannedInteraction = nextPlannedInteraction
        self.sharedInterests = sharedInterests
        self.boundaries = boundaries
        self.expectations = expectations
        self.dealBreakers = dealBreakers
    }
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
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var type: MilestoneType
    var significance: Int // 1-10
    var effects: [RelationshipEffectModel]
    var memories: [Memory]
    
    init(title: String, description: String, date: Date, type: MilestoneType, significance: Int, effects: [RelationshipEffectModel], memories: [Memory]) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.type = type
        self.significance = significance
        self.effects = effects
        self.memories = memories
    }
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
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var type: ConflictType
    var severity: Int // 1-10
    var resolution: String?
    var effects: [RelationshipEffectModel]
    var lessons: [String]
    
    init(title: String, description: String, date: Date, type: ConflictType, severity: Int, resolution: String? = nil, effects: [RelationshipEffectModel], lessons: [String]) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.type = type
        self.severity = severity
        self.resolution = resolution
        self.effects = effects
        self.lessons = lessons
    }
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
    var id: UUID
    var type: BoundaryType
    var description: String
    var importance: Int // 1-10
    var consequences: [String]
    var isRespected: Bool
    
    init(type: BoundaryType, description: String, importance: Int, consequences: [String], isRespected: Bool) {
        self.id = UUID()
        self.type = type
        self.description = description
        self.importance = importance
        self.consequences = consequences
        self.isRespected = isRespected
    }
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

// Local RelationshipEffect to avoid ambiguity with SharedTypes
struct RelationshipEffectModel: Codable {
    var id: UUID
    var type: RelationshipEffectType
    var value: Int
    var duration: TimeInterval?
    var description: String
    var target: String
    
    init(type: RelationshipEffectType, value: Int, duration: TimeInterval? = nil, description: String, target: String) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.duration = duration
        self.description = description
        self.target = target
    }
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