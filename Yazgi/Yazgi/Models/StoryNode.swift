import Foundation

struct StoryNode: Codable {
    // MARK: - Basic Information
    var id: String
    var title: String
    var description: String
    var type: StoryType
    var category: StoryCategory
    
    // MARK: - Content
    var narrative: String
    var dialogues: [Dialogue]
    var choices: [Choice]
    var conditions: [Condition]
    var outcomes: [Outcome]
    
    // MARK: - Visual Elements
    var location: Location
    var characters: [StoryCharacter]
    var atmosphere: Atmosphere
    var visualEffects: [VisualEffect]
    
    // MARK: - Gameplay Elements
    var requirements: [Requirement]
    var rewards: [Reward]
    var consequences: [Consequence]
    var achievements: [GameAchievement]
    
    // MARK: - Story Flow
    var nextNodes: [String]
    var previousNodes: [String]
    var branchingPaths: [BranchingPath]
    var timeConstraints: TimeConstraints?
    
    // MARK: - Meta Information
    var difficulty: Int // 1-10
    var replayability: Bool
    var importance: StoryImportance
    var tags: [String]
}

enum StoryType: String, Codable {
    case mainQuest = "Ana Görev"
    case sideQuest = "Yan Görev"
    case randomEvent = "Rastgele Olay"
    case characterDevelopment = "Karakter Gelişimi"
    case relationship = "İlişki"
    case career = "Kariyer"
    case education = "Eğitim"
    case family = "Aile"
    case social = "Sosyal"
    case personal = "Kişisel"
}

enum StoryCategory: String, Codable {
    case drama = "Drama"
    case romance = "Romantik"
    case adventure = "Macera"
    case mystery = "Gizem"
    case comedy = "Komedi"
    case tragedy = "Trajedi"
    case slice = "Günlük Yaşam"
    case fantasy = "Fantezi"
}

struct Dialogue: Codable {
    var speaker: String
    var text: String
    var emotion: String?
    var tone: String?
    var responses: [DialogueResponse]?
    var effects: [DialogueEffect]?
}

struct DialogueResponse: Codable {
    var text: String
    var requirements: [Requirement]?
    var effects: [DialogueEffect]
    var nextDialogue: String?
}

struct DialogueEffect: Codable {
    var target: DialogueEffectTarget
    var type: DialogueEffectType
    var value: Int
    var duration: TimeInterval?
}

enum DialogueEffectTarget: String, Codable {
    case relationship = "İlişki"
    case reputation = "İtibar"
    case emotion = "Duygu"
    case trust = "Güven"
    case knowledge = "Bilgi"
    case influence = "Etki"
}

enum DialogueEffectType: String, Codable {
    case increase = "Artış"
    case decrease = "Azalış"
    case unlock = "Kilit Açma"
    case lock = "Kilitleme"
    case trigger = "Tetikleme"
    case modify = "Değiştirme"
}

struct Choice: Codable {
    var id: String
    var text: String
    var requirements: [Requirement]
    var consequences: [Consequence]
    var outcomes: [Outcome]
    var nextNode: String?
}

struct Condition: Codable {
    var type: ConditionType
    var target: String
    var comparisonOperator: ComparisonOperator
    var value: Int
    var description: String
}

enum ConditionType: String, Codable {
    case attribute = "Özellik"
    case skill = "Yetenek"
    case relationship = "İlişki"
    case item = "Eşya"
    case achievement = "Başarım"
    case quest = "Görev"
    case location = "Konum"
    case time = "Zaman"
}

enum ComparisonOperator: String, Codable {
    case equals = "Eşittir"
    case notEquals = "Eşit Değildir"
    case greaterThan = "Büyüktür"
    case lessThan = "Küçüktür"
    case greaterThanOrEquals = "Büyük Eşittir"
    case lessThanOrEquals = "Küçük Eşittir"
    case contains = "İçerir"
    case notContains = "İçermez"
}

struct Outcome: Codable {
    var description: String
    var effects: [StoryEffect]
    var rewards: [Reward]
    var consequences: [Consequence]
    var nextNode: String?
}

struct Location: Codable {
    var name: String
    var description: String
    var type: LocationType
    var atmosphere: Atmosphere
    var requirements: [Requirement]?
    var effects: [LocationEffect]?
}

enum LocationType: String, Codable {
    case home = "Ev"
    case work = "İş"
    case school = "Okul"
    case `public` = "Kamusal"
    case nature = "Doğa"
    case entertainment = "Eğlence"
    case shopping = "Alışveriş"
    case transport = "Ulaşım"
}

struct LocationEffect: Codable {
    var target: String
    var type: StoryEffectType
    var value: Int
    var duration: TimeInterval?
}

struct StoryCharacter: Codable {
    var name: String
    var role: CharacterRole
    var relationship: Relationship?
    var dialogue: [Dialogue]
    var importance: CharacterImportance
}

enum CharacterRole: String, Codable {
    case protagonist = "Protagonist"
    case antagonist = "Antagonist"
    case mentor = "Mentor"
    case ally = "Müttefik"
    case rival = "Rakip"
    case love = "Aşk İlişkisi"
    case family = "Aile"
    case friend = "Arkadaş"
    case neutral = "Nötr"
}

enum CharacterImportance: String, Codable {
    case major = "Ana"
    case supporting = "Yardımcı"
    case minor = "Küçük"
    case background = "Arka Plan"
}

struct Atmosphere: Codable {
    var mood: String
    var weather: Weather?
    var timeOfDay: String?
    var lighting: String?
    var soundscape: String?
    var visualEffects: [VisualEffect]?
}

struct Requirement: Codable {
    var type: RequirementType
    var target: String
    var value: Int
    var description: String
}

enum RequirementType: String, Codable {
    case level = "Seviye"
    case skill = "Yetenek"
    case attribute = "Özellik"
    case item = "Eşya"
    case relationship = "İlişki"
    case quest = "Görev"
    case achievement = "Başarım"
    case location = "Konum"
}

struct Reward: Codable {
    var type: RewardType
    var value: Int
    var description: String
}

struct Consequence: Codable {
    var type: ConsequenceType
    var description: String
    var effects: [StoryEffect]
    var duration: TimeInterval?
}

enum ConsequenceType: String, Codable {
    case immediate = "Anlık"
    case shortTerm = "Kısa Vadeli"
    case longTerm = "Uzun Vadeli"
    case permanent = "Kalıcı"
}

struct StoryEffect: Codable {
    var target: StoryEffectTarget
    var type: StoryEffectType
    var value: Int
    var duration: TimeInterval?
    var description: String
}

enum StoryEffectTarget: String, Codable {
    case character = "Karakter"
    case relationship = "İlişki"
    case story = "Hikaye"
    case world = "Dünya"
    case quest = "Görev"
    case item = "Eşya"
}

enum StoryEffectType: String, Codable {
    case modify = "Değiştir"
    case add = "Ekle"
    case remove = "Kaldır"
    case unlock = "Kilit Aç"
    case lock = "Kilitle"
    case trigger = "Tetikle"
}

struct BranchingPath: Codable {
    var condition: Condition
    var nextNode: String
    var description: String
}

struct TimeConstraints: Codable {
    var duration: TimeInterval
    var type: TimeConstraintType
    var consequences: [Consequence]
}

enum TimeConstraintType: String, Codable {
    case strict = "Katı"
    case flexible = "Esnek"
    case suggested = "Önerilen"
}

enum StoryImportance: String, Codable {
    case critical = "Kritik"
    case major = "Önemli"
    case minor = "Küçük"
    case optional = "İsteğe Bağlı"
}

// MARK: - Preview Helper
extension StoryNode {
    static var preview: StoryNode {
        StoryNode(
            id: "start_university",
            title: "Üniversiteye Başlangıç",
            description: "Üniversite hayatına ilk adım",
            type: .mainQuest,
            category: .drama,
            narrative: "Üniversiteye başladığın ilk gün. Yeni bir hayata adım atıyorsun...",
            dialogues: [],
            choices: [],
            conditions: [],
            outcomes: [],
            location: Location(
                name: "Üniversite Kampüsü",
                description: "Büyük ve modern bir kampüs",
                type: .school,
                atmosphere: Atmosphere(
                    mood: "Heyecanlı",
                    weather: .sunny,
                    timeOfDay: "Sabah",
                    lighting: "Parlak",
                    soundscape: "Öğrenci sesleri",
                    visualEffects: []
                )
            ),
            characters: [],
            atmosphere: Atmosphere(
                mood: "Heyecanlı",
                weather: .sunny,
                timeOfDay: "Sabah",
                lighting: "Parlak",
                soundscape: "Öğrenci sesleri"
            ),
            visualEffects: [],
            requirements: [],
            rewards: [],
            consequences: [],
            achievements: [],
            nextNodes: [],
            previousNodes: [],
            branchingPaths: [],
            timeConstraints: nil,
            difficulty: 3,
            replayability: true,
            importance: .major,
            tags: ["Üniversite", "Eğitim", "Başlangıç"]
        )
    }
}
