import Foundation

struct StoryNode: Identifiable, Codable {
    let id: String
    let title: String?
    let description: String
    let minAge: Int
    let maxAge: Int
    let weight: Int
    let repeatable: Bool
    let requirements: [StoryRequirement]?
    let options: [StoryOption]
}

struct StoryRequirement: Codable {
    let genders: [String]?
    let countries: [String]?
    let minIntelligence: Int?
    let minBeauty: Int?
    let minLuck: Int?
    let minAura: Int?
    let maxIntelligence: Int?
}

struct StoryOption: Codable {
    let text: String
    let nextNodeId: String?
    let advanceAge: Bool?
    let effect: CharacterEffect?
}

struct CharacterEffect: Codable {
    let intelligenceChange: Int?
    let beautyChange: Int?
    let luckChange: Int?
    let auraChange: Int?
    let educationPrestigeChange: Int?
    let networkChange: Int?
    let reputationChange: Int?
    let incomePowerChange: Int?
    let setCareerPath: CareerPath?
    let healthChange: Int?
    let happinessChange: Int?
    let smartsChange: Int?
    let looksChange: Int?
    let moneyChange: Int?
    let setEducation: EducationLevel?
    let setRelationship: RelationshipStatus?
    let setJobTitle: String?
}
