import Foundation

// MARK: - Core Enums and Types

// Education System
enum EducationLevel: Int, Codable, CaseIterable, Comparable {
    case none = 0
    case primary = 1
    case highSchool = 2
    case bachelor = 3
    case master = 4
    case phd = 5
    
    var title: String {
        switch self {
        case .none: return "Eğitim Yok"
        case .primary: return "İlkokul"
        case .highSchool: return "Lise"
        case .bachelor: return "Üniversite"
        case .master: return "Yüksek Lisans"
        case .phd: return "Doktora"
        }
    }
    
    static func < (lhs: EducationLevel, rhs: EducationLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

enum EducationSystem: String, Codable {
    case traditional = "Geleneksel"
    case modern = "Modern"
    case hybrid = "Hibrit"
    case progressive = "İlerici"
    case conservative = "Muhafazakar"
}

// Socioeconomic Status
enum SocioeconomicStatus: String, Codable {
    case lowerClass = "Alt Sınıf"
    case lowerMiddleClass = "Alt Orta Sınıf"
    case middleClass = "Orta Sınıf"
    case upperMiddleClass = "Üst Orta Sınıf"
    case upperClass = "Üst Sınıf"
}

enum IncomeLevel: String, Codable {
    case low = "Düşük"
    case lowerMiddle = "Alt Orta"
    case middle = "Orta"
    case upperMiddle = "Üst Orta"
    case high = "Yüksek"
    case veryHigh = "Çok Yüksek"
}

// Relationship Types
enum RelationshipType: String, Codable {
    case family = "Aile"
    case friend = "Arkadaş"
    case romantic = "Romantik"
    case professional = "Profesyonel"
    case acquaintance = "Tanıdık"
    case mentor = "Mentor"
    case rival = "Rakip"
    case enemy = "Düşman"
}

enum RelationshipStatus: String, Codable {
    case single = "Bekar"
    case dating = "Flört"
    case engaged = "Nişanlı"
    case married = "Evli"
    case divorced = "Boşanmış"
    case widowed = "Dul"
    case separated = "Ayrı Yaşıyor"
    case friend = "Arkadaş"
    case enemy = "Düşman"
    case acquaintance = "Tanıdık"
}

// Weather and Seasons
enum Weather: String, Codable {
    case sunny = "Güneşli"
    case cloudy = "Bulutlu"
    case rainy = "Yağmurlu"
    case snowy = "Karlı"
    case stormy = "Fırtınalı"
    case foggy = "Sisli"
    case clear = "Açık"
}

enum Season: String, Codable {
    case spring = "İlkbahar"
    case summer = "Yaz"
    case autumn = "Sonbahar"
    case winter = "Kış"
}


// Achievement System
enum AchievementID: String, Codable, CaseIterable {
    case firstSteps = "first_steps"
    case firstWords = "first_words"
    case highSchoolGraduate = "high_school_graduate"
    case universityGraduate = "university_graduate"
    case valedictorian = "valedictorian"
    case ceo = "ceo"
    case millionaire = "millionaire"
    case married = "married"
    case marriage = "marriage"
    case firstLove = "first_love"
    case career = "career"
    case education = "education"
    case relationship = "relationship"
}

struct GameAchievement: Codable, Identifiable {
    let id: AchievementID
    var title: String
    var description: String
    var date: Date
    var type: AchievementType
    var difficulty: AchievementDifficulty
    var requirements: [String]
    var isUnlocked: Bool
    var dateUnlocked: Date?
    var isHidden: Bool
    var reward: GameAchievementReward?
}

enum AchievementType: String, Codable {
    case education = "Eğitim"
    case career = "Kariyer"
    case relationship = "İlişki"
    case personal = "Kişisel"
    case social = "Sosyal"
    case financial = "Finansal"
    case health = "Sağlık"
    case family = "Aile"
    case hobby = "Hobi"
    case travel = "Seyahat"
}

enum AchievementDifficulty: String, Codable {
    case easy = "Kolay"
    case medium = "Orta"
    case hard = "Zor"
    case epic = "Epik"
    case legendary = "Efsanevi"
}

struct GameAchievementReward: Codable {
    var attribute: String
    var value: Int
    var description: String
}

struct AchievementReward: Codable {
    var type: RewardType
    var value: Int
    var description: String
}

enum RewardType: String, Codable {
    case money = "Para"
    case experience = "Deneyim"
    case skill = "Yetenek"
    case reputation = "İtibar"
    case happiness = "Mutluluk"
    case health = "Sağlık"
    case energy = "Enerji"
    case attribute = "Özellik"
}

// Personality System
enum PersonalityType: String, Codable {
    case INTJ = "INTJ"
    case INTP = "INTP"
    case ENTJ = "ENTJ"
    case ENTP = "ENTP"
    case INFJ = "INFJ"
    case INFP = "INFP"
    case ENFJ = "ENFJ"
    case ENFP = "ENFP"
    case ISTJ = "ISTJ"
    case ISFJ = "ISFJ"
    case ESTJ = "ESTJ"
    case ESFJ = "ESFJ"
    case ISTP = "ISTP"
    case ISFP = "ISFP"
    case ESTP = "ESTP"
    case ESFP = "ESFP"
}

enum SexualOrientation: String, Codable {
    case heterosexual = "Heteroseksüel"
    case homosexual = "Homoseksüel"
    case bisexual = "Biseksüel"
    case pansexual = "Panseksüel"
    case asexual = "Aseksüel"
    case questioning = "Sorgulayan"
}

enum PoliticalAlignment: String, Codable {
    case farLeft = "Aşırı Sol"
    case left = "Sol"
    case centerLeft = "Merkez Sol"
    case center = "Merkez"
    case centerRight = "Merkez Sağ"
    case right = "Sağ"
    case farRight = "Aşırı Sağ"
    case apolitical = "Apolitik"
}

enum ReligiousAffiliation: String, Codable {
    case muslim = "Müslüman"
    case christian = "Hristiyan"
    case jewish = "Yahudi"
    case buddhist = "Budist"
    case hindu = "Hindu"
    case atheist = "Ateist"
    case agnostic = "Agnostik"
    case spiritual = "Ruhani"
    case other = "Diğer"
}

enum Neurodivergence: String, Codable {
    case none = "Yok"
    case adhd = "ADHD"
    case autism = "Otizm"
    case dyslexia = "Disleksi"
    case anxiety = "Anksiyete"
    case depression = "Depresyon"
    case ocd = "OKB"
    case bipolar = "Bipolar"
    case other = "Diğer"
}

// Character Effects
struct CharacterEffect: Codable, Identifiable {
    let id = UUID()
    let type: CharacterEffectType
    let value: Int
    let duration: TimeInterval?
    let source: String
    let description: String
    let isTemporary: Bool
    
    init(type: CharacterEffectType, value: Int, duration: TimeInterval? = nil, source: String, description: String, isTemporary: Bool = false) {
        self.type = type
        self.value = value
        self.duration = duration
        self.source = source
        self.description = description
        self.isTemporary = isTemporary
    }
}

enum CharacterEffectType: String, Codable {
    case health = "Sağlık"
    case energy = "Enerji"
    case happiness = "Mutluluk"
    case stress = "Stres"
    case money = "Para"
    case reputation = "İtibar"
    case influence = "Etki"
    case intelligence = "Zeka"
    case skill = "Yetenek"
    case social = "Sosyal"
    case physical = "Fiziksel"
    case mental = "Zihinsel"
}

// Memory System
struct Memory: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let emotionalImpact: Int // -10 to 10
    let people: [String]
    let location: String
    let tags: [String]
    let importance: Int // 1-10
    let type: MemoryType
    
    init(title: String, description: String, date: Date, emotionalImpact: Int, people: [String], location: String, tags: [String], importance: Int, type: MemoryType = .general) {
        self.title = title
        self.description = description
        self.date = date
        self.emotionalImpact = emotionalImpact
        self.people = people
        self.location = location
        self.tags = tags
        self.importance = importance
        self.type = type
    }
}

enum MemoryType: String, Codable {
    case general = "Genel"
    case family = "Aile"
    case education = "Eğitim"
    case relationship = "İlişki"
    case career = "Kariyer"
    case achievement = "Başarı"
    case trauma = "Travma"
    case celebration = "Kutlama"
    case social = "Sosyal"
    case personal = "Kişisel"
}

// Trait System
struct PersonalityTrait: Codable {
    var name: String
    var description: String
    var intensity: Int // 1-10
    var effects: [CharacterEffect]
    var category: TraitCategory
}

enum TraitCategory: String, Codable {
    case personality = "Kişilik"
    case physical = "Fiziksel"
    case mental = "Zihinsel"
    case social = "Sosyal"
    case emotional = "Duygusal"
    case spiritual = "Ruhsal"
}

// Game Time System
struct GameTime: Codable {
    var currentDate: Date
    var speed: TimeSpeed
    var isPaused: Bool = false
    
    init(date: Date = Date(), speed: TimeSpeed = .normal) {
        self.currentDate = date
        self.speed = speed
    }
    
    mutating func advance() {
        let timeInterval: TimeInterval
        switch speed {
        case .slow: timeInterval = 3600 // 1 hour
        case .normal: timeInterval = 86400 // 1 day
        case .fast: timeInterval = 604800 // 1 week
        }
        currentDate.addTimeInterval(timeInterval)
    }
    
    mutating func reset() {
        currentDate = Date()
        speed = .normal
        isPaused = false
    }
    
    var currentSeason: Season {
        let month = Calendar.current.component(.month, from: currentDate)
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
    
    var timeStep: TimeInterval {
        switch speed {
        case .slow: return 3600
        case .normal: return 86400
        case .fast: return 604800
        }
    }
    
    func isCharacterBirthday(_ character: Character) -> Bool {
        let calendar = Calendar.current
        let currentDay = calendar.dateComponents([.month, .day], from: currentDate)
        let birthDay = calendar.dateComponents([.month, .day], from: character.birthDate)
        return currentDay.month == birthDay.month && currentDay.day == birthDay.day
    }
    
    var isSeasonChange: Bool {
        // Implementation for season change detection
        return false
    }
    
    func getCurrentHoliday(for culture: CulturalProfile) -> Holiday? {
        // Implementation for holiday detection
        return nil
    }
    
    func getSeasonalMusic() -> String? {
        return "\(currentSeason.rawValue.lowercased())_theme"
    }
    
    func getSeasonalAmbience() -> String? {
        return "\(currentSeason.rawValue.lowercased())_ambience"
    }
    
    func isTimeForFestival(_ festival: Festival) -> Bool {
        // Implementation for festival timing
        return false
    }
}

enum TimeSpeed: String, Codable {
    case slow = "Yavaş"
    case normal = "Normal"
    case fast = "Hızlı"
}

// Mock Types for Missing Dependencies
struct Finances: Codable {
    var income: Double = 0
    var expenses: Double = 0
    var savings: Double = 0
    var debt: Double = 0
    var assets: [Asset] = []
    
    var netWorth: Double {
        return savings + assets.reduce(0) { $0 + $1.currentValue } - debt
    }
}

struct Health: Codable {
    var physicalHealth: Int = 100
    var mentalHealth: Int = 100
    var conditions: [MedicalCondition]? = []
    var medications: [String]? = []
    var allergies: [String]? = []
    var lastCheckup: Date?
    var bloodType: String?
    var height: Double?
    var weight: Double?
}

struct MedicalCondition: Codable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let severity: Int // 1-10
    let chronic: Bool
    let treatment: String?
    let effects: [CharacterEffect]
    
    init(name: String, description: String, severity: Int, chronic: Bool, treatment: String?, effects: [CharacterEffect]) {
        self.name = name
        self.description = description
        self.severity = severity
        self.chronic = chronic
        self.treatment = treatment
        self.effects = effects
    }
}

struct Holiday: Codable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let date: String
    let cultural: Bool
    let religious: Bool
    let national: Bool
    let significance: Int // 1-10
    
    init(name: String, description: String, date: String, cultural: Bool, religious: Bool, national: Bool, significance: Int) {
        self.name = name
        self.description = description
        self.date = date
        self.cultural = cultural
        self.religious = religious
        self.national = national
        self.significance = significance
    }
}

struct CulturalValues: Codable {
    var individualism: Int // 0-100
    var collectivism: Int // 0-100
    var tradition: Int // 0-100
    var modernity: Int // 0-100
    var hierarchy: Int // 0-100
    var equality: Int // 0-100
}

struct Festival: Codable {
    var name: String
    var date: String
    var duration: Int
    var significance: Int
    var activities: [String]
}

// Achievement Manager (Mock)
class AchievementManager {
    func checkAchievements(for character: Character) -> [GameAchievement] {
        return []
    }
}

// Life Stage
enum LifeStage: String, Codable {
    case infant = "Bebek"
    case toddler = "Küçük Çocuk"
    case child = "Çocuk"
    case teenager = "Ergen"
    case youngAdult = "Genç Yetişkin"
    case adult = "Yetişkin"
    case middleAged = "Orta Yaşlı"
    case senior = "Yaşlı"
    case elder = "Çok Yaşlı"
}

// Additional Types
typealias Achievement = GameAchievement

// MARK: - RelationshipEffect for fixing compilation errors
struct RelationshipEffect: Codable, Identifiable {
    let id = UUID()
    let type: RelationshipEffectType
    let value: Int
    let duration: TimeInterval?
    let description: String
    let target: String
    
    init(type: RelationshipEffectType, value: Int, duration: TimeInterval? = nil, description: String, target: String) {
        self.type = type
        self.value = value
        self.duration = duration
        self.description = description
        self.target = target
    }
}

enum RelationshipEffectType: String, Codable {
    case trust = "Güven"
    case intimacy = "Yakınlık"
    case respect = "Saygı"
    case compatibility = "Uyum"
    case tension = "Gerginlik"
    case influence = "Etki"
    case attraction = "Çekim"
    case support = "Destek"
}

// MARK: - NPCType Definitions to fix ambiguity
enum NPCType: String, Codable, CaseIterable {
    case friend = "Arkadaş"
    case teacher = "Öğretmen"
    case neighbor = "Komşu"
    case classmate = "Sınıf Arkadaşı"
    case colleague = "İş Arkadaşı"
    case familyFriend = "Aile Dostu"
    case mentor = "Mentor"
    case rival = "Rakip"
    case bully = "Zorba"
    case loveInterest = "Gönül İlişkisi"
}

// MARK: - NPC struct definition 
struct NPC: Codable, Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let occupation: String?
    let personality: PersonalityProfile
    
    static func generateRandom(matchingCharacter character: Character) -> NPC {
        return NPC(
            name: "Rastgele NPC",
            age: character.age + Int.random(in: -3...3),
            occupation: character.occupation,
            personality: .preview
        )
    }
}

// Character Extensions for Missing Methods
extension Character {
    static func createNewCharacter() -> Character {
        return Character.preview
    }
    
    mutating func apply(_ effects: [CharacterEffect]) {
        for effect in effects {
            switch effect.type {
            case .happiness:
                happiness = max(0, min(100, happiness + effect.value))
            case .health:
                health = max(0, min(100, health + effect.value))
            case .energy:
                energy = max(0, min(100, energy + effect.value))
            case .stress:
                stress = max(0, min(100, stress + effect.value))
            case .money:
                money += Double(effect.value)
            case .reputation:
                reputation = max(0, min(100, reputation + effect.value))
            case .influence:
                influence = max(0, min(100, influence + effect.value))
            default:
                break // Handle other effect types as needed
            }
        }
    }
    
    var socialSkills: Int {
        return skills.first(where: { $0.category == .social })?.level ?? 50
    }
    
    var visitedCountries: [String] {
        return []
    }
    
    var socialMedia: [String: Int] {
        return [:]
    }
    
    var activeNPCs: [NPC] {
        return []
    }
    
    mutating func updateIncome(basedOn profile: EconomicProfile) {
        // Implementation for income update
    }
    
    mutating func updateLivingCosts(_ costs: Double) {
        // Implementation for living costs update
    }
    
    mutating func updateStressResponse(_ factors: [String], _ personality: PersonalityProfile) {
        // Implementation for stress response
    }
    
    mutating func updateHappinessResponse(_ factors: [String], _ personality: PersonalityProfile) {
        // Implementation for happiness response
    }
    
    mutating func addSharedExperience(_ experience: SharedExperience, with npc: NPC) {
        // Implementation for shared experience
    }
    
    var lifeEvents: [LifeEvent] {
        get { return timeline }
        set { timeline = newValue }
    }
}

// CulturalProfile Extensions
extension CulturalProfile {
    var traditionalFestivals: [Festival] {
        return festivals.map { Festival(name: $0.name, date: $0.date, duration: $0.duration, significance: $0.significance, activities: $0.activities) }
    }
    
    var culturalValues: CulturalValues {
        return CulturalValues()
    }
    
    static var turkishProfile: CulturalProfile {
        return CulturalProfile.preview
    }
}

// PersonalityProfile Extensions
extension PersonalityProfile {
    func calculateSocialCompatibility(with other: PersonalityProfile) -> Int {
        return 50 // Mock implementation
    }
}

// Relationship Extensions
extension Relationship {
    func updateRelationship(timePassed: TimeInterval) {
        // Mock implementation
    }
    
    var person: Person {
        return Person(name: characterName, age: characterAge, occupation: characterOccupation, traits: characterTraits)
    }
}

// Person struct for relationships
struct Person: Codable {
    var name: String
    var age: Int
    var occupation: String?
    var traits: [String]
}

// StoryNode Extensions
extension StoryNode {
    static func getInitialNode(for character: Character) -> StoryNode? {
        return StoryNode.preview
    }
}

// NPC Extensions
extension NPC {
    static func generateRandom(matchingCharacter character: Character) -> NPC {
        return NPC.preview
    }
}

// Supporting Types
struct SharedExperience: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let type: SharedExperienceType
    let location: String?
    let emotionalImpact: Int // -100 to 100
    let participants: [String]
    let memories: [Memory]
    
    init(title: String, description: String, date: Date, type: SharedExperienceType, location: String?, emotionalImpact: Int, participants: [String], memories: [Memory]) {
        self.title = title
        self.description = description
        self.date = date
        self.type = type
        self.location = location
        self.emotionalImpact = emotionalImpact
        self.participants = participants
        self.memories = memories
    }
}

enum SharedExperienceType: String, Codable {
    case social = "Sosyal"
    case adventure = "Macera"
    case celebration = "Kutlama"
    case travel = "Seyahat"
    case learning = "Öğrenme"
    case support = "Destek"
    case conflict = "Çatışma"
    case milestone = "Dönüm Noktası"
}

struct EconomicProfile: Codable {
    var averageIncome: IncomeLevel
    var costOfLiving: Double
    var unemploymentRate: Double
    var economicGrowth: Double
}

// MARK: - Life Events
struct LifeEvent: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let type: LifeEventType
    let impact: Int // -100 to 100
    let effects: [CharacterEffect]
    let memories: [Memory]
    
    init(title: String, description: String, date: Date, type: LifeEventType, impact: Int, effects: [CharacterEffect], memories: [Memory]) {
        self.title = title
        self.description = description
        self.date = date
        self.type = type
        self.impact = impact
        self.effects = effects
        self.memories = memories
    }
}

enum LifeEventType: String, Codable {
    case birth = "Doğum"
    case childhood = "Çocukluk"
    case education = "Eğitim"
    case career = "Kariyer"
    case relationship = "İlişki"
    case family = "Aile"
    case health = "Sağlık"
    case achievement = "Başarı"
    case trauma = "Travma"
    case milestone = "Dönüm Noktası"
    case personal = "Kişisel"
    case social = "Sosyal"
}

// MARK: - Story Node and Effects
struct VisualEffect: Codable, Identifiable {
    let id = UUID()
    let type: VisualEffectType
    let intensity: Double
    let duration: TimeInterval?
    let color: String?
    
    init(type: VisualEffectType, intensity: Double, duration: TimeInterval?, color: String?) {
        self.type = type
        self.intensity = intensity
        self.duration = duration
        self.color = color
    }
}

enum VisualEffectType: String, Codable {
    case particles = "Parçacık"
    case glow = "Parıltı"
    case blur = "Bulanıklık"
    case shake = "Sarsıntı"
    case fade = "Solma"
    case zoom = "Büyütme"
    case rotation = "Döndürme"
    case color = "Renk"
}


// MARK: - NPC Extensions
extension NPC {
    static func generateRandom(matchingCharacter character: Character) -> NPC {
        let types: [NPCType] = [.friend, .classmate, .neighbor, .familyFriend]
        let type = types.randomElement() ?? .friend
        
        return NPC(
            name: "Rastgele NPC",
            type: type,
            age: character.age + Int.random(in: -3...3),
            gender: ["Kadın", "Erkek", "Non-binary"].randomElement() ?? "Belirsiz",
            occupation: character.occupation,
            personalityProfile: .preview,
            culturalBackground: character.culturalProfile,
            relationshipDynamic: .neutral,
            relationshipStrength: Int.random(in: 30...70),
            trustLevel: Int.random(in: 20...60),
            influence: Int.random(in: 10...50),
            interactions: [],
            sharedExperiences: [],
            memories: [],
            effects: [],
            moodTowardsPlayer: Int.random(in: 40...80),
            hasUnresolvedConflict: false,
            lastInteractionDate: nil
        )
    }
}

// MARK: - Story Node Extensions
extension StoryNode {
    static func getInitialNode(for character: Character) -> StoryNode? {
        return StoryNode.preview
    }
    
    var weather: Weather? {
        return .sunny // Default weather
    }
    
    var backgroundMusic: String? {
        return "default_music"
    }
    
    var ambientSound: String? {
        return "default_ambient"
    }
    
    var visualEffects: [VisualEffect] {
        return []
    }
}

// MARK: - Achievement System Extensions
extension AchievementSystem {
    static func createAchievement(_ id: AchievementID) -> GameAchievement {
        switch id {
        case .firstSteps:
            return GameAchievement(
                id: id,
                title: "İlk Adımlar",
                description: "İlk adımlarını attın!",
                date: Date(),
                type: .milestone,
                difficulty: .easy,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "physical",
                    value: 5,
                    description: "Fiziksel gelişim +5"
                )
            )
        case .universityGraduate:
            return GameAchievement(
                id: id,
                title: "Üniversite Mezunu",
                description: "Üniversiteden mezun oldun!",
                date: Date(),
                type: .education,
                difficulty: .medium,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "intelligence",
                    value: 10,
                    description: "Zeka +10"
                )
            )
        case .firstLove:
            return GameAchievement(
                id: id,
                title: "İlk Aşk",
                description: "İlk aşkını yaşadın!",
                date: Date(),
                type: .relationship,
                difficulty: .medium,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "happiness",
                    value: 15,
                    description: "Mutluluk +15"
                )
            )
        case .ceo:
            return GameAchievement(
                id: id,
                title: "CEO",
                description: "Şirket CEO'su oldun!",
                date: Date(),
                type: .career,
                difficulty: .legendary,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "influence",
                    value: 25,
                    description: "Etki +25"
                )
            )
        default:
            return GameAchievement(
                id: id,
                title: "Bilinmeyen Başarım",
                description: "Açıklama yok",
                date: Date(),
                type: .milestone,
                difficulty: .easy,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: nil
            )
        }
    }
}

// MARK: - Game Time Extensions
extension GameTime {
    mutating func reset() {
        date = Date()
        speed = .normal
        timeStep = 0
    }
    
    mutating func advance() {
        let advancement = speed.rawValue * 3600 // 1 hour per normal speed
        date = date.addingTimeInterval(advancement)
        timeStep += advancement
    }
    
    var currentSeason: Season {
        let month = Calendar.current.component(.month, from: date)
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
    
    func isCharacterBirthday(_ character: Character) -> Bool {
        let calendar = Calendar.current
        let characterBirthDay = calendar.dateComponents([.month, .day], from: character.birthDate)
        let currentDay = calendar.dateComponents([.month, .day], from: date)
        
        return characterBirthDay.month == currentDay.month && characterBirthDay.day == currentDay.day
    }
    
    var isSeasonChange: Bool {
        // This would need more sophisticated logic to detect season changes
        return false
    }
    
    func getCurrentHoliday(for culturalProfile: CulturalProfile) -> Holiday? {
        // Return current holiday if any
        return nil
    }
    
    func getSeasonalMusic() -> String? {
        switch currentSeason {
        case .spring: return "spring_music"
        case .summer: return "summer_music"
        case .autumn: return "autumn_music"
        case .winter: return "winter_music"
        }
    }
    
    func getSeasonalAmbience() -> String? {
        switch currentSeason {
        case .spring: return "birds_singing"
        case .summer: return "summer_ambience"
        case .autumn: return "wind_leaves"
        case .winter: return "winter_wind"
        }
    }
}

// MARK: - Extensions for Character interaction
extension Character {
    mutating func addLifeEvent(_ event: LifeEvent) {
        timeline.append(event)
        
        // Apply event effects
        for effect in event.effects {
            applyEffect(effect)
        }
        
        // Add memories if any
        memories.append(contentsOf: event.memories)
    }
    
    mutating func applyEffect(_ effect: CharacterEffect) {
        switch effect.type {
        case .health:
            health = max(0, min(100, health + effect.value))
        case .energy:
            energy = max(0, min(100, energy + effect.value))
        case .happiness:
            happiness = max(0, min(100, happiness + effect.value))
        case .stress:
            stress = max(0, min(100, stress + effect.value))
        case .money:
            money += Double(effect.value)
        case .reputation:
            reputation = max(0, min(100, reputation + effect.value))
        case .influence:
            influence = max(0, min(100, influence + effect.value))
        case .intelligence:
            // Add to skills or traits as needed
            break
        default:
            break // Handle other effect types as needed
        }
        
        // Add to active effects if temporary
        if effect.isTemporary {
            effects.append(effect)
        }
    }
    
    static func createNewCharacter() -> Character {
        return Character(
            name: "Yeni Karakter",
            age: 0,
            gender: "Belirsiz",
            birthDate: Date(),
            birthPlace: "Bilinmiyor",
            culturalProfile: .preview,
            familyBackground: .preview,
            personalityProfile: .preview,
            currentLocation: "Bilinmiyor",
            education: .none,
            occupation: nil,
            socioeconomicStatus: .middleClass,
            relationships: [],
            achievements: [],
            memories: [],
            health: 100,
            energy: 100,
            happiness: 50,
            stress: 0,
            money: 0.0,
            reputation: 50,
            influence: 0,
            finances: Finances(),
            healthSystem: Health(),
            skills: [],
            traits: [],
            goals: [],
            values: [],
            beliefs: [],
            currentStoryNode: nil,
            completedStoryNodes: [],
            timeline: [],
            inventory: [],
            effects: []
        )
    }
    
    var socialSkills: Int {
        // Calculate social skills based on personality and experience
        let baseSkills = personalityProfile.extroversion + personalityProfile.agreeableness
        let relationshipBonus = min(relationships.count * 2, 20)
        return min(100, baseSkills + relationshipBonus)
    }
    
    var lifeEvents: [LifeEvent] {
        return timeline
    }
    
    var netWorth: Double {
        let assetValue = inventory.reduce(0) { $0 + $1.currentValue }
        return money + assetValue
    }
    
    var culturalBackground: CulturalProfile {
        return culturalProfile
    }
}

// MARK: - Relationship Extensions
extension Relationship {
    mutating func updateRelationship(timePassed: TimeInterval) {
        // Update relationship over time
        let timeInDays = timePassed / (24 * 60 * 60)
        
        // Relationships naturally decay if not maintained
        if timeInDays > 30 {
            intimacy = max(0, intimacy - 1)
            trust = max(0, trust - 1)
        }
        
        // Update last interaction
        if Date().timeIntervalSince(lastInteraction) > 30 * 24 * 60 * 60 {
            interactionFrequency = .rarely
        }
    }
}

// MARK: - Game Time Extensions
extension GameTime {
    mutating func reset() {
        date = Date()
        speed = .normal
        timeStep = 0
    }
    
    mutating func advance() {
        let advancement = speed.rawValue * 3600 // 1 hour per normal speed
        date = date.addingTimeInterval(advancement)
        timeStep += advancement
    }
    
    var currentSeason: Season {
        let month = Calendar.current.component(.month, from: date)
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
    
    func isCharacterBirthday(_ character: Character) -> Bool {
        let calendar = Calendar.current
        let characterBirthDay = calendar.dateComponents([.month, .day], from: character.birthDate)
        let currentDay = calendar.dateComponents([.month, .day], from: date)
        
        return characterBirthDay.month == currentDay.month && characterBirthDay.day == currentDay.day
    }
    
    var isSeasonChange: Bool {
        // This would need more sophisticated logic to detect season changes
        return false
    }
    
    func getCurrentHoliday(for culturalProfile: CulturalProfile) -> Holiday? {
        // Return current holiday if any
        return nil
    }
    
    func getSeasonalMusic() -> String? {
        switch currentSeason {
        case .spring: return "spring_music"
        case .summer: return "summer_music"
        case .autumn: return "autumn_music"
        case .winter: return "winter_music"
        }
    }
    
    func getSeasonalAmbience() -> String? {
        switch currentSeason {
        case .spring: return "birds_singing"
        case .summer: return "summer_ambience"
        case .autumn: return "wind_leaves"
        case .winter: return "winter_wind"
        }
    }
}


// MARK: - NPC Extensions
extension NPC {
    static func generateRandom(matchingCharacter character: Character) -> NPC {
        let types: [NPCType] = [.friend, .classmate, .neighbor, .familyFriend]
        let type = types.randomElement() ?? .friend
        
        return NPC(
            name: "Rastgele NPC",
            type: type,
            age: character.age + Int.random(in: -3...3),
            gender: ["Kadın", "Erkek", "Non-binary"].randomElement() ?? "Belirsiz",
            occupation: character.occupation,
            personalityProfile: .preview,
            culturalBackground: character.culturalProfile,
            relationshipDynamic: .neutral,
            relationshipStrength: Int.random(in: 30...70),
            trustLevel: Int.random(in: 20...60),
            influence: Int.random(in: 10...50),
            interactions: [],
            sharedExperiences: [],
            memories: [],
            effects: [],
            moodTowardsPlayer: Int.random(in: 40...80),
            hasUnresolvedConflict: false,
            lastInteractionDate: nil
        )
    }
}

// MARK: - Story Node Extensions
extension StoryNode {
    static func getInitialNode(for character: Character) -> StoryNode? {
        return StoryNode.preview
    }
    
    var weather: Weather? {
        return .sunny // Default weather
    }
    
    var backgroundMusic: String? {
        return "default_music"
    }
    
    var ambientSound: String? {
        return "default_ambient"
    }
    
    var visualEffects: [VisualEffect] {
        return []
    }
}

// MARK: - Achievement System Extensions
extension AchievementSystem {
    static func createAchievement(_ id: AchievementID) -> GameAchievement {
        switch id {
        case .firstSteps:
            return GameAchievement(
                id: id,
                title: "İlk Adımlar",
                description: "İlk adımlarını attın!",
                date: Date(),
                type: .milestone,
                difficulty: .easy,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "physical",
                    value: 5,
                    description: "Fiziksel gelişim +5"
                )
            )
        case .universityGraduate:
            return GameAchievement(
                id: id,
                title: "Üniversite Mezunu",
                description: "Üniversiteden mezun oldun!",
                date: Date(),
                type: .education,
                difficulty: .medium,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "intelligence",
                    value: 10,
                    description: "Zeka +10"
                )
            )
        case .firstLove:
            return GameAchievement(
                id: id,
                title: "İlk Aşk",
                description: "İlk aşkını yaşadın!",
                date: Date(),
                type: .relationship,
                difficulty: .medium,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "happiness",
                    value: 15,
                    description: "Mutluluk +15"
                )
            )
        case .ceo:
            return GameAchievement(
                id: id,
                title: "CEO",
                description: "Şirket CEO'su oldun!",
                date: Date(),
                type: .career,
                difficulty: .legendary,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: GameAchievementReward(
                    attribute: "influence",
                    value: 25,
                    description: "Etki +25"
                )
            )
        default:
            return GameAchievement(
                id: id,
                title: "Bilinmeyen Başarım",
                description: "Açıklama yok",
                date: Date(),
                type: .milestone,
                difficulty: .easy,
                requirements: [],
                isUnlocked: true,
                dateUnlocked: Date(),
                isHidden: false,
                reward: nil
            )
        }
    }
}

// MARK: - CulturalProfile Extensions
extension CulturalProfile {
    var traditionalFestivals: [Festival] {
        return festivals.map { Festival(name: $0.name, date: $0.date, duration: $0.duration, significance: $0.significance, activities: $0.activities) }
    }
    
    var culturalValues: CulturalValues {
        return CulturalValues()
    }
    
    static var turkishProfile: CulturalProfile {
        return CulturalProfile.preview
    }
}

// MARK: - PersonalityProfile Extensions
extension PersonalityProfile {
    func calculateSocialCompatibility(with other: PersonalityProfile) -> Int {
        return 50 // Mock implementation
    }
}

// MARK: - Relationship Extensions
extension Relationship {
    mutating func updateRelationship(timePassed: TimeInterval) {
        // Update relationship over time
        let timeInDays = timePassed / (24 * 60 * 60)
        
        // Relationships naturally decay if not maintained
        if timeInDays > 30 {
            intimacy = max(0, intimacy - 1)
            trust = max(0, trust - 1)
        }
        
        // Update last interaction
        if Date().timeIntervalSince(lastInteraction) > 30 * 24 * 60 * 60 {
            interactionFrequency = .rarely
        }
    }
    
    var person: Person {
        return Person(name: characterName, age: characterAge, occupation: characterOccupation, traits: characterTraits)
    }
}

// MARK: - Person struct for relationships
struct Person: Codable {
    var name: String
    var age: Int
    var occupation: String?
    var traits: [String]
}

// MARK: - StoryNode Extensions
extension StoryNode {
    static func getInitialNode(for character: Character) -> StoryNode? {
        return StoryNode.preview
    }
}

// MARK: - NPC Extensions
extension NPC {
    static func generateRandom(matchingCharacter character: Character) -> NPC {
        return NPC.preview
    }
}

    var averageIncome: IncomeLevel
    var costOfLiving: Double
    var unemploymentRate: Double
    var economicGrowth: Double
} 