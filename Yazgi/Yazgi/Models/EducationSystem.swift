import Foundation

// Using shared types from SharedTypes.swift
struct Education: Codable {
    var level: EducationLevel
    var field: String?
    var institution: String?
    var gpa: Double?
    var graduationYear: Int?
    var ongoingEducation: Bool
    var scholarships: [Scholarship]?
    var studentDebt: Double?
    var achievements: [GameAchievement]?
    var activities: [String]?
    var skills: [String]?
    
    // Eğitim etkisi
    var effects: EducationEffects?
}

struct EducationEffects: Codable {
    var intelligenceGain: Int // 0-100 arası
    var socialSkillGain: Int // 0-100 arası
    var stressLevel: Int // 0-100 arası
    var careerOpportunities: [String]
    var relationships: [String] // Edinilen arkadaşlıklar, mentorluklar
}

struct Scholarship: Codable {
    var name: String
    var amount: Double
    var type: ScholarshipType
    var duration: Int // Yıl cinsinden
    var requirements: ScholarshipRequirements
}

enum ScholarshipType: String, Codable {
    case merit = "Başarı Bursu"
    case need = "İhtiyaç Bursu"
    case sports = "Spor Bursu"
    case arts = "Sanat Bursu"
    case full = "Tam Burs"
    case partial = "Kısmi Burs"
}

struct ScholarshipRequirements: Codable {
    var minGPA: Double?
    var maxFamilyIncome: Double?
    var specialSkills: [String]?
    var maintainGPA: Double?
}

struct EducationAchievement: Codable {
    var achievement: GameAchievement
    var impact: String
}

struct EducationManager {
    static func calculateIntelligenceGain(for level: EducationLevel, gpa: Double) -> Int {
        let baseGain = level.rawValue * 5
        let gpaBonus = Int((gpa - 2.0) * 10)
        return min(100, max(0, baseGain + gpaBonus))
    }
    
    static func calculateStressLevel(gpa: Double, activities: [String]?, scholarships: [Scholarship]?) -> Int {
        var stress = 50 // Temel stres seviyesi
        
        // GPA etkisi
        if gpa > 3.5 {
            stress += 20
        } else if gpa < 2.0 {
            stress += 30
        }
        
        // Aktivite etkisi
        if let activities = activities {
            stress += activities.count * 5
        }
        
        // Burs etkisi
        if let scholarships = scholarships {
            stress += scholarships.count * 10
        }
        
        return min(100, max(0, stress))
    }
    
    static func generateRandomEvents(level: EducationLevel) -> [LifeEvent] {
        var events: [LifeEvent] = []
        
        // Seviyeye göre olası olaylar
        switch level {
        case .highSchool:
            events.append(LifeEvent(
                title: "Üniversite Sınavı Hazırlığı",
                description: "Üniversite sınavına hazırlanıyorsun.",
                date: Date(),
                type: .education,
                impact: -5,
                effects: [
                    CharacterEffect(
                        type: .stress,
                        value: 20,
                        duration: nil,
                        source: "Sınav hazırlığı",
                        description: "Sınav stresi arttı"
                    )
                ],
                memories: []
            ))
        case .bachelor:
            events.append(LifeEvent(
                title: "Önemli Proje",
                description: "Önemli bir proje teslim etmen gerekiyor.",
                date: Date(),
                type: .education,
                impact: -3,
                effects: [
                    CharacterEffect(
                        type: .skill,
                        value: 5,
                        duration: nil,
                        source: "Proje çalışması",
                        description: "Problem çözme yeteneği arttı"
                    )
                ],
                memories: []
            ))
        default:
            break
        }
        
        return events
    }
    
    static func isEligibleForNextLevel(currentEducation: Education) -> Bool {
        guard let gpa = currentEducation.gpa else { return false }
        
        switch currentEducation.level {
        case .highSchool:
            return gpa >= 2.0
        case .bachelor:
            return gpa >= 3.0
        case .master:
            return gpa >= 3.5
        default:
            return true
        }
    }
    
    func updateEducationSystem(_ system: EducationProfile) {
        // Implementation for education system update
    }
    
    func updateLearningStyle(_ personality: PersonalityProfile) {
        // Implementation for learning style update
    }
    
    func applyEducationChange(_ character: inout Character, change: EducationChange) {
        // Implementation for education changes
        if let newLevel = change.newLevel {
            character.education = newLevel
        }
    }
}

struct EducationChange {
    let newLevel: EducationLevel?
    let graduationDate: Date?
    let gpa: Double?
}

// MARK: - Preview Helper
extension Education {
    static var preview: Education {
        Education(
            level: .highSchool,
            field: nil,
            institution: "Atatürk Lisesi",
            gpa: 3.8,
            graduationYear: 2024,
            ongoingEducation: true,
            scholarships: [
                Scholarship(
                    name: "Başarı Bursu",
                    amount: 1000,
                    type: .merit,
                    duration: 1,
                    requirements: ScholarshipRequirements(
                        minGPA: 3.5,
                        maxFamilyIncome: nil,
                        specialSkills: nil,
                        maintainGPA: 3.0
                    )
                )
            ],
            studentDebt: nil,
            achievements: [
                GameAchievement(
                    id: .education,
                    title: "Onur Öğrencisi",
                    description: "İlk dönem onur listesine girdin",
                    date: Date(),
                    type: .education,
                    difficulty: .medium,
                    requirements: [],
                    isUnlocked: true,
                    dateUnlocked: Date(),
                    isHidden: false,
                    reward: GameAchievementReward(
                        attribute: "intelligence",
                        value: 5,
                        description: "Zeka +5"
                    )
                )
            ],
            activities: ["Satranç Kulübü", "Bilim Kulübü"],
            skills: ["Problem Çözme", "Analitik Düşünme"],
            effects: EducationEffects(
                intelligenceGain: 10,
                socialSkillGain: 5,
                stressLevel: 60,
                careerOpportunities: ["Üniversite", "Yurtdışı Eğitim"],
                relationships: ["Sınıf Arkadaşları", "Öğretmenler"]
            )
        )
    }
} 