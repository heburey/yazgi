import Foundation

struct CulturalProfile: Codable {
    // MARK: - Basic Information
    var country: String
    var region: String?
    var city: String?
    var language: String
    var religion: String?
    var ethnicity: String?
    
    // MARK: - Cultural Elements
    var traditions: [Tradition]
    var customs: [Custom]
    var beliefs: [Belief]
    var values: [CulturalValue]
    var taboos: [Taboo]
    
    // MARK: - Social Structure
    var familyStructure: FamilyStructure
    var socialHierarchy: SocialHierarchy
    var genderRoles: [GenderRole]
    var marriageCustoms: [MarriageCustom]
    
    // MARK: - Daily Life
    var foodCulture: FoodCulture
    var dressCode: DressCode
    var etiquette: [Etiquette]
    var festivals: [Festival]
    
    // MARK: - Education & Career
    var educationProfile: EducationProfile
    var careerProfile: CareerProfile
    var workCulture: WorkCulture
    
    // MARK: - Art & Entertainment
    var artForms: [ArtForm]
    var music: [MusicStyle]
    var literature: [LiteraryStyle]
    var entertainment: [Entertainment]
    
    // MARK: - Economic
    var economicProfile: EconomicProfile
    
    // MARK: - Naming Patterns
    var namePatterns: NamePatterns
}

struct Tradition: Codable {
    var name: String
    var description: String
    var significance: Int // 1-10
    var frequency: String
    var participants: [String]
    var requirements: [String]
    var effects: [CulturalEffect]
}

struct Custom: Codable {
    var name: String
    var description: String
    var context: String
    var importance: Int // 1-10
    var participants: [String]
    var etiquette: [String]
}

struct Belief: Codable {
    var name: String
    var description: String
    var origin: String?
    var significance: Int // 1-10
    var practices: [String]
    var taboos: [String]
}

struct CulturalValue: Codable {
    var name: String
    var description: String
    var importance: Int // 1-10
    var manifestations: [String]
    var conflicts: [String]
}

struct Taboo: Codable {
    var name: String
    var description: String
    var severity: Int // 1-10
    var consequences: [String]
    var exceptions: [String]?
}

struct FamilyStructure: Codable {
    var type: FamilyType
    var hierarchy: [String]
    var roles: [FamilyRole]
    var expectations: [String]
    var traditions: [String]
}

enum FamilyType: String, Codable {
    case nuclear = "Çekirdek"
    case extended = "Geniş"
    case single = "Tek Ebeveynli"
    case blended = "Karma"
    case communal = "Topluluk"
}

struct FamilyRole: Codable {
    var title: String
    var description: String
    var responsibilities: [String]
    var authority: Int // 1-10
    var expectations: [String]
}

struct SocialHierarchy: Codable {
    var structure: [SocialClass]
    var mobility: Int // 1-10
    var factors: [String]
    var privileges: [String]
}

struct SocialClass: Codable {
    var name: String
    var description: String
    var status: SocioeconomicStatus
    var characteristics: [String]
    var opportunities: [String]
    var limitations: [String]
}

struct GenderRole: Codable {
    var gender: String
    var expectations: [String]
    var responsibilities: [String]
    var limitations: [String]
    var opportunities: [String]
    var evolution: String?
}

struct MarriageCustom: Codable {
    var name: String
    var description: String
    var requirements: [String]
    var traditions: [String]
    var restrictions: [String]
    var ceremonies: [String]
}

struct FoodCulture: Codable {
    var staples: [String]
    var specialDishes: [String]
    var mealTimes: [String]
    var etiquette: [String]
    var taboos: [String]
    var festivals: [String]
}

struct DressCode: Codable {
    var everyday: [String]
    var formal: [String]
    var traditional: [String]
    var religious: [String]?
    var seasonal: [String]
    var taboos: [String]
}

struct Etiquette: Codable {
    var context: String
    var rules: [String]
    var importance: Int // 1-10
    var consequences: [String]
    var exceptions: [String]?
}

struct Festival: Codable {
    var name: String
    var description: String
    var date: String
    var duration: Int
    var traditions: [String]
    var activities: [String]
    var significance: Int // 1-10
}

struct EducationProfile: Codable {
    var system: EducationSystem
    var values: [String]
    var methods: [String]
    var institutions: [String]
    var qualifications: [String]
    var specializations: [String]
}

struct CareerProfile: Codable {
    var commonPaths: [String]
    var values: [String]
    var industries: [String]
    var qualifications: [String]
    var opportunities: [String]
    var challenges: [String]
}

struct WorkCulture: Codable {
    var values: [String]
    var hierarchy: [String]
    var communication: [String]
    var workLife: [String]
    var expectations: [String]
    var benefits: [String]
}

struct ArtForm: Codable {
    var name: String
    var description: String
    var history: String?
    var techniques: [String]
    var significance: Int // 1-10
    var practitioners: [String]
}

struct MusicStyle: Codable {
    var name: String
    var description: String
    var instruments: [String]
    var occasions: [String]
    var significance: Int // 1-10
    var examples: [String]
}

struct LiteraryStyle: Codable {
    var name: String
    var description: String
    var genres: [String]
    var themes: [String]
    var significance: Int // 1-10
    var examples: [String]
}

struct Entertainment: Codable {
    var name: String
    var description: String
    var participants: [String]
    var occasions: [String]
    var rules: [String]?
    var significance: Int // 1-10
}

struct NamePatterns: Codable {
    var maleFirstNames: [String]
    var femaleFirstNames: [String]
    var familyNames: [String]
    var namingTraditions: [String]
    var meanings: [String: String]
    var restrictions: [String]?
}

struct CulturalEffect: Codable {
    var type: CulturalEffectType
    var value: Int // -100 to 100
    var duration: TimeInterval?
    var description: String
}

enum CulturalEffectType: String, Codable {
    case reputation = "İtibar"
    case relationships = "İlişkiler"
    case opportunities = "Fırsatlar"
    case restrictions = "Kısıtlamalar"
    case resources = "Kaynaklar"
}

// MARK: - Preview Helper
extension CulturalProfile {
    static var preview: CulturalProfile {
        CulturalProfile(
            country: "Türkiye",
            region: "Marmara",
            city: "İstanbul",
            language: "Türkçe",
            religion: "İslam",
            ethnicity: "Türk",
            traditions: [],
            customs: [],
            beliefs: [],
            values: [],
            taboos: [],
            familyStructure: FamilyStructure(
                type: .extended,
                hierarchy: ["Büyükbaba", "Büyükanne", "Baba", "Anne", "Çocuklar"],
                roles: [],
                expectations: [],
                traditions: []
            ),
            socialHierarchy: SocialHierarchy(
                structure: [],
                mobility: 6,
                factors: [],
                privileges: []
            ),
            genderRoles: [],
            marriageCustoms: [],
            foodCulture: FoodCulture(
                staples: [],
                specialDishes: [],
                mealTimes: [],
                etiquette: [],
                taboos: [],
                festivals: []
            ),
            dressCode: DressCode(
                everyday: [],
                formal: [],
                traditional: [],
                religious: nil,
                seasonal: [],
                taboos: []
            ),
            etiquette: [],
            festivals: [],
            educationProfile: EducationProfile(
                system: .modern,
                values: [],
                methods: [],
                institutions: [],
                qualifications: [],
                specializations: []
            ),
            careerProfile: CareerProfile(
                commonPaths: [],
                values: [],
                industries: [],
                qualifications: [],
                opportunities: [],
                challenges: []
            ),
            workCulture: WorkCulture(
                values: [],
                hierarchy: [],
                communication: [],
                workLife: [],
                expectations: [],
                benefits: []
            ),
            artForms: [],
            music: [],
            literature: [],
            entertainment: [],
            economicProfile: EconomicProfile(
                averageIncome: .upperMiddle,
                costOfLiving: 15000,
                unemploymentRate: 0.12,
                economicGrowth: 0.03
            ),
            namePatterns: NamePatterns(
                maleFirstNames: [],
                femaleFirstNames: [],
                familyNames: [],
                namingTraditions: [],
                meanings: [:],
                restrictions: nil
            )
        )
    }
} 