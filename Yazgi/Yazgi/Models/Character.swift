import Foundation

struct Character: Codable {
    // MARK: - Basic Information
    var name: String
    var age: Int
    var gender: String
    var birthDate: Date
    var birthPlace: String
    
    // MARK: - Background
    var culturalProfile: CulturalProfile
    var familyBackground: FamilyBackground
    var personalityProfile: PersonalityProfile
    
    // MARK: - Current Status
    var currentLocation: String
    var education: EducationLevel
    var occupation: String?
    var socioeconomicStatus: SocioeconomicStatus
    var relationships: [Relationship]
    var achievements: [GameAchievement]
    var memories: [Memory]
    
    // MARK: - Stats & Attributes
    var health: Int // 0-100
    var energy: Int // 0-100
    var happiness: Int // 0-100
    var stress: Int // 0-100
    var money: Double
    var reputation: Int // 0-100
    var influence: Int // 0-100
    
    var netWorth: Double {
        return money + assets.reduce(0) { $0 + $1.currentValue }
    }
    var intelligence: Int // 0-100
    var aura: Int // 0-100
    var beauty: Int // 0-100
    var luck: Int // 0-100
    var karma: Int // -100 to +100
    
    // MARK: - Systems
    var finances: Finances
    var healthSystem: Health
    
    // MARK: - Skills & Development
    var skills: [Skill]
    var traits: [CharacterTrait]
    var goals: [Goal]
    var values: [String]
    var beliefs: [String]
    
    // MARK: - Story & Progress
    var currentStoryNode: StoryNode?
    var completedStoryNodes: [String]
    var timeline: [LifeEvent]
    var inventory: [Asset]
    var effects: [CharacterEffect]
    
    // MARK: - Computed Properties
    var currentLifeStage: LifeStage {
        switch age {
        case 0...2: return .infant
        case 3...5: return .toddler
        case 6...12: return .child
        case 13...19: return .teenager
        case 20...35: return .youngAdult
        case 36...55: return .adult
        case 56...70: return .middleAged
        case 71...85: return .senior
        default: return .elder
        }
    }
    
    var educationStatus: String {
        return education.title
    }
    
    var wealthStatus: String {
        switch money {
        case 0..<10_000: return "Düşük"
        case 10_000..<50_000: return "Orta"
        case 50_000..<200_000: return "İyi"
        case 200_000..<1_000_000: return "Yüksek"
        default: return "Çok Yüksek"
        }
    }
    
    // MARK: - Achievements Check
    mutating func checkForNewAchievements() {
        // Education achievements
        if education >= .bachelor && !achievements.contains(where: { $0.id == .universityGraduate }) {
            achievements.append(AchievementSystem.createAchievement(.universityGraduate))
        }
        
        // Relationship achievements
        if relationships.contains(where: { $0.status == .married }) && !achievements.contains(where: { $0.id == .firstLove }) {
            achievements.append(AchievementSystem.createAchievement(.firstLove))
        }
        
        // Career achievements
        if let job = occupation, job.lowercased().contains("ceo") && !achievements.contains(where: { $0.id == .ceo }) {
            achievements.append(AchievementSystem.createAchievement(.ceo))
        }
    }
    
    // MARK: - Life Events
    mutating func addLifeEvent(_ event: LifeEvent) {
        timeline.append(event)
        
        // Apply event effects
        for effect in event.effects {
            applyEffect(effect)
        }
        
        // Add memories if any
        memories.append(contentsOf: event.memories)
    }
}

struct Skill: Codable {
    var name: String
    var level: Int // 0-100
    var experience: Int
    var category: SkillCategory
    var relatedTraits: [String]
    var masteryLevel: SkillMastery
}

enum SkillCategory: String, Codable {
    case academic = "Akademik"
    case artistic = "Sanatsal"
    case athletic = "Sportif"
    case business = "İş"
    case communication = "İletişim"
    case crafting = "El Sanatları"
    case culinary = "Mutfak"
    case digital = "Dijital"
    case language = "Dil"
    case leadership = "Liderlik"
    case musical = "Müzikal"
    case social = "Sosyal"
    case technical = "Teknik"
}

enum SkillMastery: String, Codable {
    case novice = "Acemi"
    case apprentice = "Çırak"
    case intermediate = "Orta Seviye"
    case advanced = "İleri Seviye"
    case expert = "Uzman"
    case master = "Usta"
}

struct CharacterTrait: Codable {
    var name: String
    var description: String
    var type: TraitType
    var intensity: Int // 1-10
    var effects: [TraitEffect]
}

enum TraitType: String, Codable {
    case personality = "Kişilik"
    case physical = "Fiziksel"
    case mental = "Zihinsel"
    case social = "Sosyal"
    case emotional = "Duygusal"
    case spiritual = "Ruhsal"
}

struct TraitEffect: Codable {
    var target: TraitEffectTarget
    var value: Int // -100 to 100
    var condition: String?
    var duration: TimeInterval?
}

enum TraitEffectTarget: String, Codable {
    case health = "Sağlık"
    case energy = "Enerji"
    case happiness = "Mutluluk"
    case stress = "Stres"
    case money = "Para"
    case reputation = "İtibar"
    case influence = "Etki"
    case relationship = "İlişki"
    case skill = "Yetenek"
}

struct Goal: Codable {
    var title: String
    var description: String
    var type: GoalType
    var priority: GoalPriority
    var progress: Int // 0-100
    var deadline: Date?
    var requirements: [String]
    var rewards: [GoalReward]
}

enum GoalType: String, Codable {
    case education = "Eğitim"
    case career = "Kariyer"
    case relationship = "İlişki"
    case personal = "Kişisel"
    case financial = "Finansal"
    case health = "Sağlık"
    case lifestyle = "Yaşam Tarzı"
    case spiritual = "Ruhsal"
}

enum GoalPriority: String, Codable {
    case low = "Düşük"
    case medium = "Orta"
    case high = "Yüksek"
    case critical = "Kritik"
}

struct GoalReward: Codable {
    var type: RewardType
    var value: Int
    var description: String
}

struct LifeEvent: Codable {
    var title: String
    var description: String
    var date: Date
    var type: LifeEventType
    var impact: Int // -100 to 100
    var effects: [CharacterEffect]
    var memories: [Memory]
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

// Extension to handle effect application
extension Character {
    mutating func apply(_ effects: [CharacterEffect]) {
        for effect in effects {
            applyEffect(effect)
        }
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
            intelligence = max(0, min(100, intelligence + effect.value))
        default:
            break // Handle other effect types as needed
        }
    }
    
    mutating func addLifeEvent(_ event: LifeEvent) {
        // Life events are handled via SharedTypes extension
    }
}

// MARK: - Preview Helper
extension Character {
    static var preview: Character {
        Character(
            name: "Deniz Yılmaz",
            age: 18,
            gender: "Non-binary",
            birthDate: Date(),
            birthPlace: "Türkiye",
            culturalProfile: .preview,
            familyBackground: .preview,
            personalityProfile: .preview,
            currentLocation: "Türkiye",
            education: .highSchool,
            occupation: nil,
            socioeconomicStatus: .middleClass,
            relationships: [],
            achievements: [],
            memories: [],
            health: 85,
            energy: 75,
            happiness: 80,
            stress: 30,
            money: 1000.0,
            reputation: 70,
            influence: 60,
            intelligence: 75,
            aura: 65,
            beauty: 70,
            luck: 60,
            karma: 10,
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
}
