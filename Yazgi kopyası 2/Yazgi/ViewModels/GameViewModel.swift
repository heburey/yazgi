import SwiftUI

class GameViewModel: ObservableObject {
    @Published var character: Character
    @Published var currentNode: StoryNode
    
    init(character: Character) {
        self.character = character
        
        // Başlangıç story node'unu yükle
        if let jsonData = try? Data(contentsOf: Bundle.main.url(forResource: "StoryData", withExtension: "json")!),
           let storyNodes = try? JSONDecoder().decode([StoryNode].self, from: jsonData),
           let startNode = storyNodes.first(where: { $0.id == "start" }) {
            self.currentNode = startNode
        } else {
            // Fallback node (hata durumu için)
            self.currentNode = StoryNode(
                id: "error",
                description: "Hikaye yüklenemedi...",
                options: []
            )
        }
    }
    
    func choose(option: StoryOption) {
        // Seçimin etkilerini uygula
        if let effect = option.effect {
            if let intelligenceChange = effect.intelligenceChange {
                character.intelligence = max(0, min(100, character.intelligence + intelligenceChange))
            }
            if let beautyChange = effect.beautyChange {
                character.beauty = max(0, min(100, character.beauty + beautyChange))
            }
            if let luckChange = effect.luckChange {
                character.luck = max(0, min(100, character.luck + luckChange))
            }
            if let auraChange = effect.auraChange {
                character.aura = max(0, min(100, character.aura + auraChange))
            }
        }
        
        // Sonraki node'a geç
        if let jsonData = try? Data(contentsOf: Bundle.main.url(forResource: "StoryData", withExtension: "json")!),
           let storyNodes = try? JSONDecoder().decode([StoryNode].self, from: jsonData),
           let nextNode = storyNodes.first(where: { $0.id == option.nextNodeId }) {
            self.currentNode = nextNode
        }
    }
}
