import Foundation

// Remove duplicate definitions and use SharedTypes

struct AchievementRequirements: Codable {
    var minAge: Int?
    var maxAge: Int?
    var minEducation: EducationLevel?
    var minWealth: Double?
    var requiredRelationships: [String]?
    var requiredSkills: [String]?
    var requiredAchievements: [AchievementID]?
    var requiredEvents: [String]?
    var customConditions: [String]?
}

struct AchievementSystem {
    static func checkAchievements(for character: Character) -> [GameAchievement] {
        var newAchievements: [GameAchievement] = []
        
        // Education achievements
        if character.education >= .highSchool && !character.achievements.contains(where: { $0.id == .highSchoolGraduate }) {
            newAchievements.append(createAchievement(.highSchoolGraduate))
        }
        
        if character.education >= .bachelor && !character.achievements.contains(where: { $0.id == .universityGraduate }) {
            newAchievements.append(createAchievement(.universityGraduate))
        }
        
        // Career achievements
        if let occupation = character.occupation {
            if occupation.contains("CEO") && !character.achievements.contains(where: { $0.id == .ceo }) {
                newAchievements.append(createAchievement(.ceo))
            }
        }
        
        // Wealth achievements
        if character.money >= 1_000_000 && !character.achievements.contains(where: { $0.id == .millionaire }) {
            newAchievements.append(createAchievement(.millionaire))
        }
        
        // Relationship achievements
        if character.relationships.contains(where: { $0.status == .married }) && !character.achievements.contains(where: { $0.id == .marriage }) {
            newAchievements.append(createAchievement(.marriage))
        }
        
        return newAchievements
    }
    
    static func createAchievement(_ id: AchievementID) -> GameAchievement {
        let achievementData = getAchievementData(for: id)
        
        return GameAchievement(
            id: id,
            title: achievementData.title,
            description: achievementData.description,
            date: Date(),
            type: achievementData.type,
            difficulty: achievementData.difficulty,
            requirements: achievementData.requirements,
            isUnlocked: true,
            dateUnlocked: Date(),
            isHidden: false,
            reward: achievementData.reward
        )
    }
    
    private static func getAchievementData(for id: AchievementID) -> (title: String, description: String, type: AchievementType, difficulty: AchievementDifficulty, requirements: [String], reward: GameAchievementReward?) {
        switch id {
        case .firstSteps:
            return ("İlk Adımlar", "İlk adımlarını attın!", .personal, .easy, [], GameAchievementReward(attribute: "health", value: 5, description: "Sağlık +5"))
        case .firstWords:
            return ("İlk Kelimeler", "İlk kelimelerini söyledin!", .personal, .easy, [], GameAchievementReward(attribute: "intelligence", value: 5, description: "Zeka +5"))
        case .highSchoolGraduate:
            return ("Lise Mezunu", "Liseyi başarıyla bitirdin!", .education, .medium, ["Lise eğitimi"], GameAchievementReward(attribute: "intelligence", value: 10, description: "Zeka +10"))
        case .universityGraduate:
            return ("Üniversite Mezunu", "Üniversiteyi başarıyla bitirdin!", .education, .hard, ["Üniversite eğitimi"], GameAchievementReward(attribute: "intelligence", value: 20, description: "Zeka +20"))
        case .valedictorian:
            return ("Onur Öğrencisi", "Sınıfının birincisi oldun!", .education, .hard, ["Yüksek not ortalaması"], GameAchievementReward(attribute: "reputation", value: 15, description: "İtibar +15"))
        case .ceo:
            return ("CEO", "Bir şirketin CEO'su oldun!", .career, .epic, ["Liderlik becerileri"], GameAchievementReward(attribute: "influence", value: 25, description: "Etki +25"))
        case .millionaire:
            return ("Milyoner", "İlk milyonunu kazandın!", .financial, .hard, ["1 milyon TL servet"], GameAchievementReward(attribute: "reputation", value: 20, description: "İtibar +20"))
        case .married:
            return ("Evli", "Evlendin!", .relationship, .medium, ["Romantik ilişki"], GameAchievementReward(attribute: "happiness", value: 15, description: "Mutluluk +15"))
        case .marriage:
            return ("Evlilik", "Evlilik kurumuna adım attın!", .relationship, .medium, ["Evlilik"], GameAchievementReward(attribute: "happiness", value: 15, description: "Mutluluk +15"))
        case .firstLove:
            return ("İlk Aşk", "İlk aşkını yaşadın!", .relationship, .easy, ["Romantik ilişki"], GameAchievementReward(attribute: "happiness", value: 10, description: "Mutluluk +10"))
        case .career:
            return ("Kariyer", "Kariyerinde ilerleme kaydettın!", .career, .medium, ["İş deneyimi"], GameAchievementReward(attribute: "reputation", value: 10, description: "İtibar +10"))
        case .education:
            return ("Eğitim", "Eğitim hayatında başarı gösterdin!", .education, .medium, ["Eğitim başarısı"], GameAchievementReward(attribute: "intelligence", value: 10, description: "Zeka +10"))
        case .relationship:
            return ("İlişki", "İlişkilerinde başarı gösterdin!", .relationship, .medium, ["Sosyal becerileri"], GameAchievementReward(attribute: "reputation", value: 10, description: "İtibar +10"))
        }
    }
    
    // Achievement progress tracking
    static func trackProgress(for character: Character, achievement: AchievementID) -> Double {
        let requirements = getRequirementsFor(achievement)
        return calculateProgress(character: character, requirements: requirements)
    }
    
    private static func getRequirementsFor(_ achievement: AchievementID) -> AchievementRequirements {
        switch achievement {
        case .highSchoolGraduate:
            return AchievementRequirements(minEducation: .highSchool)
        case .universityGraduate:
            return AchievementRequirements(minEducation: .bachelor)
        case .millionaire:
            return AchievementRequirements(minWealth: 1_000_000)
        case .married:
            return AchievementRequirements(requiredRelationships: ["spouse"])
        default:
            return AchievementRequirements()
        }
    }
    
    private static func calculateProgress(character: Character, requirements: AchievementRequirements) -> Double {
        var progress: Double = 0
        var totalRequirements = 0
        
        if let minEducation = requirements.minEducation {
            totalRequirements += 1
            if character.education >= minEducation {
                progress += 1
            }
        }
        
        if let minWealth = requirements.minWealth {
            totalRequirements += 1
            if character.money >= minWealth {
                progress += 1
            } else {
                progress += min(1.0, character.money / minWealth)
            }
        }
        
        if let requiredRelationships = requirements.requiredRelationships {
            totalRequirements += requiredRelationships.count
            for relationship in requiredRelationships {
                if relationship == "spouse" && character.relationships.contains(where: { $0.status == .married }) {
                    progress += 1
                }
            }
        }
        
        return totalRequirements > 0 ? progress / Double(totalRequirements) : 1.0
    }
}

// MARK: - Preview Helper
extension GameAchievement {
    static var preview: GameAchievement {
        GameAchievement(
            id: .universityGraduate,
            title: "Üniversite Mezunu",
            description: "Üniversiteyi başarıyla bitirdin!",
            date: Date(),
            type: .education,
            difficulty: .hard,
            requirements: ["Üniversite eğitimi"],
            isUnlocked: true,
            dateUnlocked: Date(),
            isHidden: false,
            reward: GameAchievementReward(
                attribute: "intelligence",
                value: 20,
                description: "Zeka +20"
            )
        )
    }
} 