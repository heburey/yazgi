import Foundation

enum CareerField: String, Codable, CaseIterable {
    case technology = "Teknoloji"
    case healthcare = "Sağlık"
    case education = "Eğitim"
    case business = "İş Dünyası"
    case law = "Hukuk"
    case arts = "Sanat"
    case engineering = "Mühendislik"
    case science = "Bilim"
    case media = "Medya"
    case sports = "Spor"
    case service = "Hizmet"
    case government = "Kamu"
}

enum CareerLevel: Int, Codable, CaseIterable, Comparable {
    case intern = 0
    case entry = 1
    case junior = 2
    case midLevel = 3
    case senior = 4
    case lead = 5
    case manager = 6
    case director = 7
    case executive = 8
    case ceo = 9
    
    var title: String {
        switch self {
        case .intern: return "Stajyer"
        case .entry: return "Yeni Mezun"
        case .junior: return "Junior"
        case .midLevel: return "Orta Seviye"
        case .senior: return "Kıdemli"
        case .lead: return "Takım Lideri"
        case .manager: return "Yönetici"
        case .director: return "Direktör"
        case .executive: return "Üst Düzey Yönetici"
        case .ceo: return "CEO"
        }
    }
    
    static func < (lhs: CareerLevel, rhs: CareerLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Career: Codable {
    var field: CareerField
    var title: String
    var company: String
    var level: CareerLevel
    var salary: Double
    var startDate: Date
    var endDate: Date?
    var skills: [String]
    var achievements: [GameAchievement]
    var projects: [Project]?
    var satisfaction: Int // 0-100 arası
    var stress: Int // 0-100 arası
    var relationships: [WorkRelationship]?
    var promotionProgress: Int // 0-100 arası
    var performance: Int // 0-100 arası
    var promotionHistory: [Promotion] = []
    
    // Hesaplanan özellikler
    var yearsOfExperience: Int {
        let end = endDate ?? Date()
        let components = Calendar.current.dateComponents([.year], from: startDate, to: end)
        return components.year ?? 0
    }
    
    var isEligibleForPromotion: Bool {
        let minimumYearsInLevel = 2
        let lastPromotion = promotionHistory.last
        
        if let last = lastPromotion {
            let components = Calendar.current.dateComponents([.year], from: last.date, to: Date())
            return (components.year ?? 0) >= minimumYearsInLevel
        }
        
        return yearsOfExperience >= minimumYearsInLevel
    }
}

struct CareerAchievement: Codable {
    var achievement: GameAchievement
    var impact: String
    
    init(title: String, description: String, date: Date, impact: String, reward: GameAchievementReward?) {
        self.achievement = GameAchievement(
            id: .ceo, // This should be determined based on the achievement
            title: title,
            description: description,
            date: date,
            type: .career,
            difficulty: .medium, // This should be determined based on the achievement
            requirements: [],
            isUnlocked: true,
            dateUnlocked: date,
            isHidden: false,
            reward: reward
        )
        self.impact = impact
    }
}

struct Promotion: Codable {
    var fromLevel: CareerLevel
    var toLevel: CareerLevel
    var date: Date
    var salaryIncrease: Double
    var reason: String
}

struct PerformanceReview: Codable {
    var date: Date
    var rating: Int // 1-5 arası
    var strengths: [String]
    var areasForImprovement: [String]
    var feedback: String
    var goals: [String]
    var salaryAdjustment: Double?
    var bonusAmount: Double?
}

struct Project: Codable {
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date?
    var status: ProjectStatus
    var role: String
    var teamSize: Int
    var technologies: [String]
    var achievements: [String]
    var impact: String
}

enum ProjectStatus: String, Codable {
    case planning = "Planlama"
    case inProgress = "Devam Ediyor"
    case completed = "Tamamlandı"
    case onHold = "Beklemede"
    case cancelled = "İptal Edildi"
}

struct WorkRelationship: Codable {
    var person: String
    var role: WorkRole
    var quality: Int // 0-100 arası
    var influence: Int // 0-100 arası
}

enum WorkRole: String, Codable {
    case supervisor = "Yönetici"
    case colleague = "İş Arkadaşı"
    case subordinate = "Ast"
    case mentor = "Mentor"
    case mentee = "Mentee"
    case client = "Müşteri"
}

enum WorkStyle: String, Codable {
    case office = "Ofis"
    case remote = "Uzaktan"
    case hybrid = "Hibrit"
}

struct CareerSystem {
    static func calculateSalary(field: CareerField, level: CareerLevel, performance: Int, location: String) -> Double {
        let baseMultiplier = Double(level.rawValue + 1)
        let fieldMultiplier: Double
        
        switch field {
        case .technology, .healthcare, .law:
            fieldMultiplier = 1.5
        case .business, .engineering:
            fieldMultiplier = 1.3
        case .education, .service:
            fieldMultiplier = 0.8
        default:
            fieldMultiplier = 1.0
        }
        
        let performanceBonus = Double(performance) / 100.0 * 0.2
        let locationMultiplier = location == "İstanbul" ? 1.2 : 1.0
        
        let baseSalary = 10000.0 // Minimum maaş
        return baseSalary * baseMultiplier * fieldMultiplier * (1 + performanceBonus) * locationMultiplier
    }
    
    static func calculatePromotionChance(career: Career) -> Double {
        var chance = 0.0
        
        // Temel faktörler
        chance += Double(career.performance) * 0.4
        chance += Double(career.satisfaction) * 0.2
        chance += Double(career.promotionProgress) * 0.3
        
        // Deneyim faktörü
        let yearsInPosition = Calendar.current.dateComponents([.year], from: career.startDate, to: Date()).year ?? 0
        chance += Double(min(yearsInPosition, 5)) * 5.0
        
        // Stres penaltısı
        chance -= Double(career.stress) * 0.1
        
        return min(max(chance, 0), 100)
    }
    
    static func generateRandomEvents(career: Career) -> [LifeEvent] {
        var events: [LifeEvent] = []
        
        // Performans değerlendirmesi
        if career.performance > 80 {
            events.append(LifeEvent(
                title: "Üstün Başarı",
                description: "Yıllık değerlendirmede üstün başarı gösterdin!",
                date: Date(),
                type: LifeEventType.career,
                impact: 8,
                effects: [
                    CharacterEffect(
                        type: .happiness,
                        value: 10,
                        duration: nil,
                        source: "Performans değerlendirmesi",
                        description: "Mutluluğun arttı"
                    ),
                    CharacterEffect(
                        type: .money,
                        value: Int(career.salary * 0.1),
                        duration: nil,
                        source: "Bonus",
                        description: "Bonus kazandın"
                    )
                ],
                memories: []
            ))
        }
        
        // Proje krizi
        if let project = career.projects?.first(where: { $0.status == .inProgress }) {
            events.append(LifeEvent(
                title: "Proje Krizi",
                description: "\(project.name) projesinde kritik bir sorun ortaya çıktı.",
                date: Date(),
                type: LifeEventType.career,
                impact: -5,
                effects: [
                    CharacterEffect(
                        type: .stress,
                        value: 20,
                        duration: nil,
                        source: "Proje krizi",
                        description: "Stresin arttı"
                    ),
                    CharacterEffect(
                        type: .skill,
                        value: 5,
                        duration: nil,
                        source: "Problem çözme",
                        description: "Problem çözme yeteneğin gelişti"
                    )
                ],
                memories: []
            ))
        }
        
        return events
    }
    
    static func calculateBurnoutRisk(career: Career) -> Int {
        var risk = 0
        
        // Stres etkisi
        risk += career.stress / 2
        
        // Çalışma süresi etkisi
        let hoursPerWeek = 40 // Varsayılan
        if hoursPerWeek > 50 {
            risk += (hoursPerWeek - 50) * 2
        }
        
        // İş tatmini etkisi
        risk -= career.satisfaction / 2
        
        // İş-yaşam dengesi etkisi
        // TODO: İş-yaşam dengesi metriği eklenecek
        
        return min(max(risk, 0), 100)
    }
}

// MARK: - Preview Helper
extension Career {
    static var preview: Career {
        Career(
            field: .technology,
            title: "Yazılım Geliştirici",
            company: "Tech Co.",
            level: .midLevel,
            salary: 25000,
            startDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
            endDate: nil,
            skills: ["Swift", "SwiftUI", "iOS", "Git"],
            achievements: [],
            projects: [
                Project(
                    name: "Mobil Uygulama",
                    description: "Yeni nesil mobil uygulama geliştirme",
                    startDate: Date(),
                    endDate: nil,
                    status: .inProgress,
                    role: "Geliştirici",
                    teamSize: 5,
                    technologies: ["Swift", "SwiftUI"],
                    achievements: ["MVP Lansmanı"],
                    impact: "10K+ kullanıcı"
                )
            ],
            satisfaction: 75,
            stress: 60,
            relationships: [
                WorkRelationship(
                    person: "Ali Yılmaz",
                    role: .supervisor,
                    quality: 80,
                    influence: 70
                )
            ],
            promotionProgress: 60,
            performance: 85
        )
    }
} 