import Foundation

struct StoryNode: Identifiable, Codable {
    var id: String
    var description: String
    var options: [StoryOption]
}

struct StoryOption: Codable {
    var text: String
    var nextNodeId: String
    var effect: CharacterEffect?
}

struct CharacterEffect: Codable {
    var intelligenceChange: Int?
    var beautyChange: Int?
    var luckChange: Int?
    var auraChange: Int?
}
