import Foundation

struct StoryNode: Codable {
    // MARK: - Basic Information  
    var id: String
    var description: String
    var type: String?
    var age: Int?
    
    // MARK: - Content
    var options: [StoryOption] = []
    var customContent: [CustomContent]?
    var timeOfDay: String?
    var weather: String?
    var season: String?
    var transitionType: String?
    var mood: String?
    
    // MARK: - Media
    var backgroundImage: String?
    var backgroundMusic: String?
    var ambientSound: String?
    
    // MARK: - Effects & Requirements
    var visualEffects: [JSONVisualEffect]?
    var requirements: JSONRequirements?
    var waitForInput: Bool?
    
    // Optional meta information for backwards compatibility
    var title: String? {
        return description
    }
    
    var narrative: String? {
        return description
    }
}

// Minimal types for JSON parsing

struct StoryOption: Codable {
    var text: String
    var nextNodeId: String?
    var effect: StoryEffects?
    var visualStyle: OptionStyle?
    var probability: Double?
}

struct CustomContent: Codable {
    var type: String
    var content: String
    var style: [String: String]?
}

enum TimeOfDay: String, Codable {
    case dawn = "Şafak"
    case morning = "Sabah"
    case afternoon = "Öğleden Sonra"
    case evening = "Akşam"
    case night = "Gece"
    case midnight = "Gece Yarısı"
}

enum Season: String, Codable {
    case spring = "İlkbahar"
    case summer = "Yaz"
    case autumn = "Sonbahar"
    case winter = "Kış"
}

struct OptionStyle: Codable {
    var backgroundColor: String?
    var textColor: String?
    var borderColor: String?
    var icon: String?
    var isGlowing: Bool?
    var isPulsing: Bool?
}

struct StoryEffects: Codable {
    var intelligenceChange: Int?
    var beautyChange: Int?
    var luckChange: Int?
    var auraChange: Int?
    var happinessChange: Int?
    var stressChange: Int?
    var karmaChange: Int?
    var healthChange: HealthChange?
    var relationshipChanges: [RelationshipChange]?
}

struct HealthChange: Codable {
    var physicalHealth: Int?
    var mentalHealth: Int?
}

struct RelationshipChange: Codable {
    var targetId: String
    var changeType: String
    var magnitude: Int
}

struct JSONVisualEffect: Codable {
    var type: String
    var intensity: Double?
    var duration: Double?
    var delay: Double?
    var color: String?
}

struct JSONRequirements: Codable {
    var minAge: Int?
    var maxAge: Int?
}

// MARK: - Preview Helper
extension StoryNode {
    static var preview: StoryNode {
        StoryNode(
            id: "start_university",
            description: "Üniversite hayatına ilk adım. Büyük bir kampüsün önünde duruyorsun.",
            type: "life",
            age: 18,
            options: [
                StoryOption(
                    text: "Kampüsü keşfet",
                    nextNodeId: "explore_campus",
                    effect: StoryEffects(intelligenceChange: 5),
                    visualStyle: nil,
                    probability: 1.0
                )
            ],
            customContent: nil,
            timeOfDay: "morning",
            weather: "sunny",
            season: "autumn",
            transitionType: "fade",
            mood: "heyecanli",
            backgroundImage: "university_campus",
            backgroundMusic: "uplifting_orchestral",
            ambientSound: "student_chatter",
            visualEffects: nil,
            requirements: nil,
            waitForInput: true
        )
    }
    
    static var `default`: StoryNode {
        return StoryNode.preview
    }
    
    static func getInitialNode(for character: Character) -> StoryNode? {
        // Character'e göre başlangıç node'unu belirle
        return loadStoryNode("start") ?? StoryNode.preview
    }
    
    static func loadStoryNode(_ nodeId: String) -> StoryNode? {
        guard let url = Bundle.main.url(forResource: "StoryData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let storyNodes = try? JSONDecoder().decode([StoryNode].self, from: data) else {
            return nil
        }
        
        return storyNodes.first { $0.id == nodeId }
    }
}
