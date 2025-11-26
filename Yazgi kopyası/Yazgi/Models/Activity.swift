import Foundation

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let category: ActivityCategory
    let minAge: Int
    let maxAge: Int
    let weight: Int
    let requirements: [StoryRequirement]?
    let effect: CharacterEffect?
}

enum ActivityCategory: String {
    case health = "Sağlık"
    case social = "Sosyal"
    case education = "Eğitim"
    case career = "Kariyer"
    case finance = "Finans"
    case activism = "Aktivizm"
    case leisure = "Keyif"
    case relationship = "İlişki"
}
