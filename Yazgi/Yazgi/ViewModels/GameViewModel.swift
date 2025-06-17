import SwiftUI

class GameViewModel: ObservableObject {
    @Published var character: Character
    @Published var gameTime: GameTime
    @Published var storyProgress: [String: Bool]
    @Published var achievements: [GameAchievement]
    @Published var currentStoryNode: StoryNode?
    @Published var showingEvent: Bool = false
    @Published var showingAchievement: Bool = false
    @Published var latestAchievement: GameAchievement?
    @Published var weatherEffect: WeatherEffect?
    @Published var backgroundMusic: String?
    @Published var ambientSound: String?
    
    // Alt sistemler
    private let effectManager: EffectManager
    private let decisionEngine: DecisionEngine
    private let lifeSimulator: LifeSimulator
    private let eventGenerator: EventGenerator
    private let relationshipManager: RelationshipManager
    private let careerManager: CareerManager
    private let educationManager: EducationManager
    private let achievementManager: AchievementManager
    private let soundManager: SoundManager
    
    init(character: Character? = nil) {
        // Alt sistemleri başlat
        self.effectManager = EffectManager()
        self.decisionEngine = DecisionEngine()
        self.lifeSimulator = LifeSimulator()
        self.eventGenerator = EventGenerator()
        self.relationshipManager = RelationshipManager()
        self.careerManager = CareerManager()
        self.educationManager = EducationManager()
        self.achievementManager = AchievementManager()
        self.soundManager = SoundManager()
        
        // Karakter oluştur veya yükle
        if let character = character {
            self.character = character
        } else {
            self.character = Character.createNewCharacter()
        }
        
        // Oyun zamanını başlat
        self.gameTime = GameTime(
            date: Calendar.current.date(byAdding: .year, value: -self.character.age, to: Date()) ?? Date(),
            speed: .normal
        )
        
        // İlerleme ve başarımları başlat
        self.storyProgress = [:]
        self.achievements = []
        
        // İlk hikaye düğümünü yükle
        loadInitialStoryNode()
    }
    
    // MARK: - Game Flow
    func startNewGame() {
        // Yeni oyun başlatma işlemleri
        character = Character.createNewCharacter()
        gameTime.reset()
        storyProgress.removeAll()
        achievements.removeAll()
        loadInitialStoryNode()
        
        // Başlangıç efektlerini ayarla
        updateWeatherEffect()
        playBackgroundMusic("intro")
    }
    
    func loadGame(_ save: GameSave) {
        // Kayıtlı oyunu yükle
        character = save.character
        gameTime = save.gameTime
        storyProgress = save.storyProgress
        achievements = save.achievements
        
        // Mevcut duruma göre efektleri ayarla
        updateWeatherEffect()
        updateAmbientSounds()
    }
    
    func saveGame() throws {
        try GamePersistence.shared.saveGame(
            character: character,
            gameTime: gameTime,
            storyProgress: storyProgress,
            achievements: achievements
        )
    }
    
    // MARK: - Story & Events
    private func loadInitialStoryNode() {
        if let node = StoryNode.getInitialNode(for: character) {
            currentStoryNode = node
            applyNodeEffects(node)
        }
    }
    
    func makeChoice(_ choice: String) {
        guard let node = currentStoryNode else { return }
        
        // Kararı değerlendir ve sonuçları hesapla
        let outcome = decisionEngine.evaluateChoice(choice, for: node, character: character)
        
        // Sonuçları uygula
        applyOutcome(outcome)
        
        // Başarımları kontrol et
        checkAchievements()
        
        // Bir sonraki düğüme geç
        if let nextNode = outcome.nextNode {
            transitionToNode(nextNode)
        }
    }
    
    private func applyOutcome(_ outcome: DecisionOutcome) {
        // Karakter üzerindeki etkileri uygula
        character.apply(outcome.effects)
        
        // İlişkileri güncelle
        relationshipManager.updateRelationships(character: &character, outcome: outcome)
        
        // Kariyer değişikliklerini uygula
        if let careerChange = outcome.careerChange {
            careerManager.applyCareerChange(&character, change: careerChange)
        }
        
        // Eğitim değişikliklerini uygula
        if let educationChange = outcome.educationChange {
            educationManager.applyEducationChange(&character, change: educationChange)
        }
    }
    
    private func transitionToNode(_ node: StoryNode) {
        // Geçiş efektini başlat
        effectManager.startTransition(from: currentStoryNode, to: node)
        
        // Düğümü değiştir
        currentStoryNode = node
        
        // Yeni düğümün efektlerini uygula
        applyNodeEffects(node)
    }
    
    private func applyNodeEffects(_ node: StoryNode) {
        // Hava durumunu güncelle
        if let weather = node.weather {
            updateWeatherEffect(to: weather)
        }
        
        // Müzik ve sesleri güncelle
        if let music = node.backgroundMusic {
            playBackgroundMusic(music)
        }
        if let ambient = node.ambientSound {
            playAmbientSound(ambient)
        }
        
        // Görsel efektleri uygula
        effectManager.applyVisualEffects(node.visualEffects)
    }
    
    // MARK: - Time Management
    func advanceTime() {
        gameTime.advance()
        
        // Zamanla ilgili olayları kontrol et
        checkTimeBasedEvents()
        
        // NPC'leri güncelle
        updateNPCs()
        
        // Rastgele olayları kontrol et
        checkRandomEvents()
        
        // Başarımları kontrol et
        checkAchievements()
    }
    
    private func checkTimeBasedEvents() {
        // Doğum günü
        if gameTime.isCharacterBirthday(character) {
            character.age += 1
            triggerBirthdayEvent()
        }
        
        // Mevsimsel olaylar
        if gameTime.isSeasonChange {
            updateSeasonalEffects()
        }
        
        // Özel günler ve bayramlar
        if let holiday = gameTime.getCurrentHoliday(for: character.culturalProfile) {
            triggerHolidayEvent(holiday)
        }
    }
    
    private func updateNPCs() {
        // NPC'lerin durumlarını güncelle
        for i in character.relationships.indices {
            character.relationships[i].updateRelationship(timePassed: gameTime.timeStep)
        }
        
        // Yeni NPC'ler oluştur
        if shouldGenerateNewNPC() {
            let npc = NPC.generateRandom(matchingCharacter: character)
            character.relationships.append(Relationship(with: npc))
        }
    }
    
    private func checkRandomEvents() {
        // Rastgele olayları kontrol et ve tetikle
        if let event = eventGenerator.generateRandomEvent(for: character, at: gameTime) {
            triggerEvent(event)
        }
    }
    
    // MARK: - Effects & Audio
    private func updateWeatherEffect(to weather: Weather? = nil) {
        if let weather = weather {
            weatherEffect = WeatherEffect(type: weather)
        } else {
            weatherEffect = WeatherEffect(season: gameTime.currentSeason)
        }
    }
    
    private func updateSeasonalEffects() {
        // Mevsime göre görsel efektleri güncelle
        effectManager.updateSeasonalEffects(for: gameTime.currentSeason)
        
        // Mevsime uygun müzik ve sesleri ayarla
        updateBackgroundMusic()
        updateAmbientSounds()
    }
    
    private func playBackgroundMusic(_ track: String) {
        soundManager.playBackgroundMusic(track)
        backgroundMusic = track
    }
    
    private func playAmbientSound(_ sound: String) {
        soundManager.playAmbientSound(sound)
        ambientSound = sound
    }
    
    private func updateBackgroundMusic() {
        if let music = gameTime.getSeasonalMusic() {
            playBackgroundMusic(music)
        }
    }
    
    private func updateAmbientSounds() {
        if let sound = gameTime.getSeasonalAmbience() {
            playAmbientSound(sound)
        }
    }
    
    // MARK: - Achievements
    private func checkAchievements() {
        let newAchievements = achievementManager.checkAchievements(for: character)
        
        for achievement in newAchievements {
            if !achievements.contains(where: { $0.id == achievement.id }) {
                achievements.append(achievement)
                showAchievement(achievement)
            }
        }
    }
    
    private func showAchievement(_ achievement: GameAchievement) {
        latestAchievement = achievement
        showingAchievement = true
        
        // Başarım efektlerini oynat
        effectManager.playAchievementEffect()
        soundManager.playAchievementSound()
    }
    
    // MARK: - Helper Functions
    private func shouldGenerateNewNPC() -> Bool {
        // NPC oluşturma mantığı
        let baseChance = 0.1 // Günlük %10 şans
        let socialModifier = Double(character.socialSkills) / 100.0
        let currentRelationships = character.relationships.count
        let relationshipModifier = max(0, 1.0 - (Double(currentRelationships) / 20.0))
        
        return Double.random(in: 0...1) < (baseChance * socialModifier * relationshipModifier)
    }
    
    private func triggerBirthdayEvent() {
        let event = LifeEvent(
            title: "\(character.age). yaş günü",
            description: "\(character.age). yaş gününü kutluyorsun!",
            date: gameTime.currentDate,
            type: .personal,
            impact: 8,
            effects: [
                CharacterEffect(
                    type: .happiness,
                    value: 10,
                    source: "Doğum günü",
                    description: "Mutluluk arttı"
                ),
                CharacterEffect(
                    type: .reputation,
                    value: 5,
                    source: "Doğum günü",
                    description: "Sosyal ilişkiler güçlendi"
                )
            ],
            memories: [
                Memory(
                    title: "\(character.age). Yaş Günü",
                    description: "Aileme ve arkadaşlarımla kutladığımız güzel bir gün",
                    date: gameTime.currentDate,
                    emotionalImpact: 8,
                    people: character.relationships.map { $0.characterName },
                    location: character.currentLocation,
                    tags: ["doğum günü", "kutlama"],
                    importance: 7
                )
            ]
        )
        
        triggerEvent(event)
    }
    
    private func triggerHolidayEvent(_ holiday: Holiday) {
        let event = LifeEvent(
            title: holiday.name,
            description: holiday.description,
            date: gameTime.currentDate,
            type: .social,
            impact: 7,
            effects: [
                CharacterEffect(
                    type: .happiness,
                    value: 15,
                    source: holiday.name,
                    description: "Tatil keyfi"
                )
            ],
            memories: [
                Memory(
                    title: holiday.name,
                    description: "\(holiday.name) kutlaması",
                    date: gameTime.currentDate,
                    emotionalImpact: 7,
                    people: character.relationships.map { $0.characterName },
                    location: character.currentLocation,
                    tags: ["tatil", "kutlama"],
                    importance: 6
                )
            ]
        )
        
        triggerEvent(event)
    }
    
    private func triggerEvent(_ event: LifeEvent) {
        character.addLifeEvent(event)
        showingEvent = true
    }
}

// MARK: - Sub-Systems
class EffectManager {
    func startTransition(from: StoryNode?, to: StoryNode) {
        // Geçiş efektlerini yönet
    }
    
    func applyVisualEffects(_ effects: [VisualEffect]) {
        // Görsel efektleri uygula
    }
    
    func updateSeasonalEffects(for season: Season) {
        // Mevsimsel efektleri güncelle
    }
    
    func playAchievementEffect() {
        // Başarım efektini göster
    }
}

class DecisionEngine {
    func evaluateChoice(_ choice: String, for node: StoryNode, character: Character) -> DecisionOutcome {
        // Kararı değerlendir ve sonuçları hesapla
        DecisionOutcome(effects: [CharacterEffect(type: .happiness, value: 5, source: "Karar", description: "Karar alındı")], nextNode: nil)
    }
    
    func updatePersonalityWeights(_ personality: PersonalityProfile) {
        // Karar verme mekanizmasını güncelle
    }
}

class LifeSimulator {
    func simulateDay(for character: inout Character, time: GameTime) {
        // Günlük yaşam simülasyonu
    }
}

class EventGenerator {
    func generateRandomEvent(for character: Character, at time: GameTime) -> LifeEvent? {
        // Rastgele olay oluştur
        nil
    }
}

class RelationshipManager {
    func updateRelationships(character: inout Character, outcome: DecisionOutcome) {
        // İlişkileri güncelle
    }
    
    func updateSocialNorms(_ norms: SocialProfile) {
        // Sosyal normları ve değerleri güncelle
    }
    
    func updatePersonalityFactors(_ personality: PersonalityProfile) {
        // Kişilik faktörlerini güncelle
    }
    
    func updateNPCDynamics(_ npc: NPC, with character: Character) {
        // İlişki dinamiklerini güncelle
    }
    
    func updateNPCToNPCRelationship(_ npc1: NPC, _ npc2: NPC) {
        // NPC'ler arası ilişkileri güncelle
    }
    
    func applyExperienceEffects(_ experience: SharedExperience, between character: Character, and npc: NPC) {
        // İlişki etkilerini uygula
    }
}

class CareerManager {
    func applyCareerChange(_ character: inout Character, change: CareerChange) {
        // Kariyer değişikliklerini uygula
    }
    
    func updateCareerOptions(_ options: CareerProfile) {
        // Kariyer seçeneklerini güncelle
    }
    
    func updateEconomicOpportunities(_ profile: EconomicProfile) {
        // Ekonomik fırsatları güncelle
    }
    
    func updatePersonalityPreferences(_ personality: PersonalityProfile) {
        // Kişilik tercihlerini güncelle
    }
}

class SoundManager {
    func playBackgroundMusic(_ track: String) {
        // Müzik çal
    }
    
    func playAmbientSound(_ sound: String) {
        // Ambiyans sesi çal
    }
    
    func playAchievementSound() {
        // Başarım sesi çal
    }
}

// MARK: - Supporting Types
struct DecisionOutcome {
    let effects: [CharacterEffect]
    let nextNode: StoryNode?
    let careerChange: CareerChange?
    let educationChange: EducationChange?
    
    init(effects: [CharacterEffect], nextNode: StoryNode?, careerChange: CareerChange? = nil, educationChange: EducationChange? = nil) {
        self.effects = effects
        self.nextNode = nextNode
        self.careerChange = careerChange
        self.educationChange = educationChange
    }
}

struct CareerChange {
    let newCareer: Career?
    let salaryChange: Double?
    let promotionLevel: CareerLevel?
}

struct WeatherEffect {
    let type: Weather
    let intensity: Double
    
    init(type: Weather) {
        self.type = type
        self.intensity = Double.random(in: 0.3...1.0)
    }
    
    init(season: Season) {
        switch season {
        case .spring:
            self.type = .rainy
            self.intensity = 0.4
        case .summer:
            self.type = .sunny
            self.intensity = 0.8
        case .autumn:
            self.type = .cloudy
            self.intensity = 0.6
        case .winter:
            self.type = .snowy
            self.intensity = 0.7
        }
    }
}

// Mock Types
struct SocialProfile: Codable {
    var values: [String] = []
}

extension Relationship {
    init(with npc: NPC) {
        self.init(
            type: .acquaintance,
            status: .acquaintance,
            startDate: Date(),
            characterName: npc.name,
            characterAge: npc.age,
            characterOccupation: npc.occupation,
            characterTraits: [],
            intimacy: 10,
            trust: 10,
            respect: 10,
            compatibility: 50,
            tension: 10,
            influence: 5,
            memories: [],
            sharedExperiences: [],
            milestones: [],
            conflicts: [],
            effects: [],
            communicationStyle: .open,
            interactionFrequency: .rarely,
            lastInteraction: Date(),
            sharedInterests: [],
            boundaries: [],
            expectations: [],
            dealBreakers: []
        )
    }
}
