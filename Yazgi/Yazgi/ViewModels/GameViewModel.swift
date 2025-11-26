import SwiftUI

struct LifeEvent: Identifiable {
    let id = UUID()
    let age: Int
    let title: String
    let choice: String
    let impact: String?
    let kind: LifeEventKind
}

enum LifeEventKind {
    case main
    case activity
    case age
    case random
    case career
    case relationship
    case milestone
}

class GameViewModel: ObservableObject {
    @Published var character: Character
    @Published var currentNode: StoryNode
    @Published var lifeLog: [LifeEvent] = []
    @Published var availableActivities: [Activity] = []
    @Published var actionsThisYear: Int = 0
    @Published var mainEventResolved: Bool = false

    var canAdvanceYear: Bool { true }

    private var storyNodes: [StoryNode] = []
    private var nodesById: [String: StoryNode] = [:]
    private var visitedOnce: Set<String> = []

    init(character: Character) {
        self.character = character

        storyNodes = GameViewModel.loadStoryNodes()
        nodesById = Dictionary(uniqueKeysWithValues: storyNodes.map { ($0.id, $0) })

        if let start = nodesById["start"] {
            currentNode = start
        } else {
            currentNode = StoryNode(
                id: "start-fallback",
                title: "İlk nefes",
                description: "Hikaye dosyası bulunamadı, kendi hikayeni yazmaya devam et.",
                minAge: 0,
                maxAge: 0,
                weight: 1,
                repeatable: false,
                requirements: nil,
                options: [
                    StoryOption(text: "Devam et", nextNodeId: nil, advanceAge: false, effect: nil)
                ]
            )
        }

        availableActivities = generateActivities(for: character.age)
    }

    func choose(option: StoryOption) {
        guard !mainEventResolved else { return }
        guard !character.isDead else { return }

        let impact = apply(effect: option.effect)
        let title = currentNode.title ?? String(currentNode.description.prefix(48))

        lifeLog.insert(
            LifeEvent(age: character.age, title: title, choice: option.text, impact: impact, kind: .main),
            at: 0
        )
        visitedOnce.insert(currentNode.id)
        actionsThisYear += 1
        mainEventResolved = true

        if option.advanceAge ?? false {
            advanceYear()
            return
        }

        if let nextId = option.nextNodeId,
           let nextNode = nodesById[nextId],
           nodeIsEligible(nextNode) {
            currentNode = nextNode
            return
        }

        currentNode = selectNextNode(for: character.age)
    }

    func use(activity: Activity) {
        guard !character.isDead else { return }
        let impact = apply(effect: activity.effect)
        actionsThisYear += 1
        lifeLog.insert(
            LifeEvent(
                age: character.age,
                title: activity.title,
                choice: activity.summary,
                impact: impact,
                kind: .activity
            ),
            at: 0
        )
        availableActivities.removeAll { $0.id == activity.id }
    }

    func logCategoryVisit(_ title: String, note: String = "Kategoriye göz attın") {
        lifeLog.insert(
            LifeEvent(
                age: character.age,
                title: title,
                choice: note,
                impact: nil,
                kind: .activity
            ),
            at: 0
        )
    }

    func advanceYear() {
        guard !character.isDead else { return }
        
        character.age += 1
        assignOrientationIfNeeded()
        actionsThisYear = 0
        mainEventResolved = false

        // Check for death
        if checkForDeath() {
            return
        }

        // Process salary and money
        processSalary()
        
        // Update spouse relationship
        updateSpouseRelationship()
        
        // Age children
        ageChildren()
        
        // Check for milestones
        checkMilestones()
        
        // Random events (BitLife style)
        if Bool.random(probability: 0.3) {
            triggerRandomEvent()
        }
        
        // First job opportunity at 18
        if character.age == 18 && character.jobTitle == nil {
            if Bool.random(probability: 0.4) {
                offerFirstJob()
            }
        }
        
        // Career progression chance
        if character.age >= 18 && character.jobTitle != nil {
            if Bool.random(probability: 0.15) {
                tryCareerProgression()
            }
        }
        
        // Relationship events
        if character.age >= 16 && character.relationshipStatus == .single {
            if Bool.random(probability: 0.2) {
                tryRelationshipEvent()
            }
        }

        let drift = applyYearlyDrift()

        lifeLog.insert(
            LifeEvent(age: character.age, title: "Yaş Aldın", choice: "Yeni yıl başlıyor", impact: drift, kind: .age),
            at: 0
        )

        currentNode = selectNextNode(for: character.age)
        availableActivities = generateActivities(for: character.age)
    }

    private func selectNextNode(for age: Int) -> StoryNode {
        if age == 0, let start = nodesById["start"] {
            return start
        }

        let eligible = storyNodes.filter { node in
            guard node.minAge <= age && age <= node.maxAge else { return false }
            if !node.repeatable && visitedOnce.contains(node.id) { return false }
            return requirementsSatisfied(node.requirements)
        }

        guard !eligible.isEmpty else {
            return quietYearNode(for: age)
        }

        let totalWeight = eligible.reduce(0) { partial, node in
            partial + max(node.weight, 1)
        }

        var roll = Int.random(in: 1...totalWeight)
        for node in eligible {
            roll -= max(node.weight, 1)
            if roll <= 0 {
                return node
            }
        }

        return eligible.randomElement() ?? quietYearNode(for: age)
    }

    private func quietYearNode(for age: Int) -> StoryNode {
        StoryNode(
            id: "quiet-\(age)-\(UUID().uuidString.prefix(6))",
            title: "Sakin bir yıl",
            description: "Bu yıl büyük bir kırılma olmadı. Küçük alışkanlıklar, gelecekteki büyük kararların zeminini hazırlıyor.",
            minAge: age,
            maxAge: age,
            weight: 1,
            repeatable: true,
            requirements: nil,
            options: [
                StoryOption(text: "Rutinine devam et", nextNodeId: nil, advanceAge: false, effect: nil)
            ]
        )
    }

    private func nodeIsEligible(_ node: StoryNode) -> Bool {
        guard node.minAge <= character.age && character.age <= node.maxAge else { return false }
        if !node.repeatable && visitedOnce.contains(node.id) { return false }
        return requirementsSatisfied(node.requirements)
    }

    private func apply(effect: CharacterEffect?) -> String? {
        guard let effect = effect else { return nil }

        var changes: [String] = []

        if let delta = effect.intelligenceChange {
            character.intelligence = clamp(character.intelligence + delta)
            changes.append("Zeka \(signed(delta))")
        }
        if let delta = effect.beautyChange {
            character.beauty = clamp(character.beauty + delta)
            changes.append("Güzellik \(signed(delta))")
        }
        if let delta = effect.luckChange {
            character.luck = clamp(character.luck + delta)
            changes.append("Şans \(signed(delta))")
        }
        if let delta = effect.auraChange {
            character.aura = clamp(character.aura + delta)
            changes.append("Aura \(signed(delta))")
        }
        if let delta = effect.educationPrestigeChange {
            character.educationPrestige = clamp(character.educationPrestige + delta)
            changes.append("Eğitim prestiji \(signed(delta))")
        }
        if let delta = effect.networkChange {
            character.network = clamp(character.network + delta)
            changes.append("Network \(signed(delta))")
        }
        if let delta = effect.reputationChange {
            character.reputation = clamp(character.reputation + delta)
            changes.append("Saygınlık \(signed(delta))")
        }
        if let delta = effect.incomePowerChange {
            character.incomePower = clamp(character.incomePower + delta)
            changes.append("Maddi güç \(signed(delta))")
        }
        if let career = effect.setCareerPath {
            character.careerPath = career
            changes.append("Kariyer odağı \(career.rawValue)")
        }
        if let delta = effect.healthChange {
            character.health = clamp(character.health + delta)
            changes.append("Sağlık \(signed(delta))")
        }
        if let delta = effect.happinessChange {
            character.happiness = clamp(character.happiness + delta)
            changes.append("Mutluluk \(signed(delta))")
        }
        if let delta = effect.smartsChange {
            character.smarts = clamp(character.smarts + delta)
            changes.append("Zeka \(signed(delta))")
        }
        if let delta = effect.looksChange {
            character.looks = clamp(character.looks + delta)
            changes.append("Görünüm \(signed(delta))")
        }
        if let delta = effect.moneyChange {
            character.money = max(0, character.money + delta)
            changes.append("Para \(signed(delta))₺")
        }
        if let edu = effect.setEducation {
            character.educationLevel = edu
            changes.append("Eğitim \(edu.rawValue)")
        }
        if let rel = effect.setRelationship {
            character.relationshipStatus = rel
            changes.append("İlişki durumu \(rel.rawValue)")
        }
        if let job = effect.setJobTitle {
            character.jobTitle = job
            changes.append("İş: \(job)")
        }

        return changes.isEmpty ? nil : changes.joined(separator: ", ")
    }

    private func requirementsSatisfied(_ requirements: [StoryRequirement]?) -> Bool {
        guard let requirements, !requirements.isEmpty else { return true }

        return requirements.allSatisfy { req in
            if let genders = req.genders, !genders.isEmpty, !genders.contains(character.gender) {
                return false
            }
            if let countries = req.countries, !countries.isEmpty, !countries.contains(character.country) {
                return false
            }
            if let minIntelligence = req.minIntelligence, character.intelligence < minIntelligence {
                return false
            }
            if let minBeauty = req.minBeauty, character.beauty < minBeauty {
                return false
            }
            if let minLuck = req.minLuck, character.luck < minLuck {
                return false
            }
            if let minAura = req.minAura, character.aura < minAura {
                return false
            }
            if let maxIntelligence = req.maxIntelligence, character.intelligence > maxIntelligence {
                return false
            }
            return true
        }
    }

    private func assignOrientationIfNeeded() {
        guard character.sexualOrientation == .questioning, character.age >= 12 else { return }

        let roll = Int.random(in: 1...100)
        switch roll {
        case 1...55:
            character.sexualOrientation = .heterosexual
        case 56...70:
            character.sexualOrientation = .homosexual
        case 71...90:
            character.sexualOrientation = .bisexualPan
        case 91...98:
            character.sexualOrientation = .asexual
        default:
            character.sexualOrientation = .bisexualPan
        }
    }

    private func clamp(_ value: Int) -> Int {
        min(100, max(0, value))
    }

    private func signed(_ value: Int) -> String {
        value > 0 ? "+\(value)" : "\(value)"
    }

    private func generateActivities(for age: Int) -> [Activity] {
        let candidates = Self.activityPool.filter { activity in
            guard activity.minAge <= age && age <= activity.maxAge else { return false }
            return requirementsSatisfied(activity.requirements)
        }

        guard !candidates.isEmpty else { return [] }

        var pool = candidates
        var selected: [Activity] = []
        let targetCount = min(max(3, candidates.count / 2), 6)

        while !pool.isEmpty && selected.count < targetCount {
            let pick = weightedChoice(from: pool)
            selected.append(pick)
            pool.removeAll { $0.id == pick.id }
        }

        return selected
    }

    private func weightedChoice(from pool: [Activity]) -> Activity {
        let total = pool.reduce(0) { $0 + max($1.weight, 1) }
        var roll = Int.random(in: 1...total)
        for item in pool {
            roll -= max(item.weight, 1)
            if roll <= 0 {
                return item
            }
        }
        return pool.randomElement() ?? pool[0]
    }

    private func applyYearlyDrift() -> String? {
        var changes: [String] = []

        var beautyDelta = Int.random(in: -1...1)
        if character.age > 30 { beautyDelta = Int.random(in: -2...1) }
        if beautyDelta != 0 {
            character.beauty = clamp(character.beauty + beautyDelta)
            character.looks = clamp(character.looks + beautyDelta)
            changes.append("Görünüm \(signed(beautyDelta))")
        }

        let luckDelta = Int.random(in: -1...1)
        if luckDelta != 0 {
            character.luck = clamp(character.luck + luckDelta)
            changes.append("Şans \(signed(luckDelta))")
        }

        let reputationDelta = character.age > 16 ? Int.random(in: 0...2) : 0
        if reputationDelta != 0 {
            character.reputation = clamp(character.reputation + reputationDelta)
            changes.append("Saygınlık +\(reputationDelta)")
        }

        let incomeDelta = character.age > 18 ? Int.random(in: 0...3) : 0
        if incomeDelta != 0 {
            character.incomePower = clamp(character.incomePower + incomeDelta)
            changes.append("Maddi güç +\(incomeDelta)")
        }

        let healthDelta = Int.random(in: -1...1)
        if healthDelta != 0 {
            character.health = clamp(character.health + healthDelta)
            changes.append("Sağlık \(signed(healthDelta))")
        }

        let happinessDelta = Int.random(in: -1...2)
        if happinessDelta != 0 {
            character.happiness = clamp(character.happiness + happinessDelta)
            changes.append("Mutluluk \(signed(happinessDelta))")
        }

        return changes.isEmpty ? nil : changes.joined(separator: ", ")
    }

    private static func loadStoryNodes() -> [StoryNode] {
        guard
            let url = Bundle.main.url(forResource: "StoryData", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let nodes = try? JSONDecoder().decode([StoryNode].self, from: data)
        else {
            return []
        }

        return nodes
    }
    
    // MARK: - BitLife-like Features
    
    private func checkForDeath() -> Bool {
        // Death by low health
        if character.health <= 0 {
            character.isDead = true
            character.deathCause = "Sağlık sorunları"
            character.yearOfDeath = character.age
            lifeLog.insert(
                LifeEvent(age: character.age, title: "Öldün", choice: "Sağlığın çok düşüktü", impact: nil, kind: .random),
                at: 0
            )
            return true
        }
        
        // Death by very low happiness (suicide risk)
        if character.happiness <= 5 && character.age >= 12 {
            if Bool.random(probability: 0.1) {
                character.isDead = true
                character.deathCause = "Depresyon"
                character.yearOfDeath = character.age
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Öldün", choice: "Mutluluğun çok düşüktü", impact: nil, kind: .random),
                    at: 0
                )
                return true
            }
        }
        
        // Random death events (accidents, illness)
        if character.age > 5 {
            let deathChance = min(0.01, Double(character.age - 5) * 0.0001)
            if Bool.random(probability: deathChance) {
                character.isDead = true
                let causes = ["Kaza", "Hastalık", "Doğal nedenler"]
                character.deathCause = causes.randomElement() ?? "Bilinmeyen"
                character.yearOfDeath = character.age
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Öldün", choice: character.deathCause ?? "Bilinmeyen neden", impact: nil, kind: .random),
                    at: 0
                )
                return true
            }
        }
        
        return false
    }
    
    private func processSalary() {
        if character.salary > 0 {
            let yearlyIncome = character.salary
            character.money += yearlyIncome
            
            // Expenses
            let expenses = Int(Double(yearlyIncome) * 0.3) // 30% expenses
            character.money -= expenses
            
            if character.spouse != nil {
                character.money -= Int(Double(yearlyIncome) * 0.2) // Additional spouse expenses
            }
            
            if !character.children.isEmpty {
                let childExpenses = character.children.count * Int(Double(yearlyIncome) * 0.1)
                character.money -= childExpenses
            }
        }
    }
    
    private func updateSpouseRelationship() {
        guard var spouse = character.spouse else { return }
        
        spouse.yearsTogether += 1
        spouse.age += 1
        
        // Relationship quality can change
        let change = Int.random(in: -5...5)
        spouse.relationshipQuality = clamp(spouse.relationshipQuality + change)
        
        // Divorce chance if relationship is very bad
        if spouse.relationshipQuality < 20 && character.age >= 18 {
            if Bool.random(probability: 0.15) {
                character.spouse = nil
                character.relationshipStatus = .single
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Boşandın", choice: "\(spouse.name) ile ayrıldın", impact: "Mutluluk -10", kind: .relationship),
                    at: 0
                )
                character.happiness = clamp(character.happiness - 10)
                return
            }
        }
        
        character.spouse = spouse
    }
    
    private func ageChildren() {
        for i in character.children.indices {
            character.children[i].age += 1
        }
    }
    
    private func checkMilestones() {
        // Education milestones
        if character.age == 6 && character.educationLevel == .primary {
            if !character.achievements.contains("İlkokula Başladı") {
                character.achievements.append("İlkokula Başladı")
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Milestone", choice: "İlkokula başladın!", impact: nil, kind: .milestone),
                    at: 0
                )
            }
        }
        
        if character.age == 12 && character.educationLevel == .secondary {
            if !character.achievements.contains("Ortaokula Başladı") {
                character.achievements.append("Ortaokula Başladı")
            }
        }
        
        if character.age == 18 && character.educationLevel == .university {
            if !character.achievements.contains("Üniversiteye Başladı") {
                character.achievements.append("Üniversiteye Başladı")
            }
        }
        
        // First job
        if character.jobTitle != nil && !character.achievements.contains("İlk İş") {
            character.achievements.append("İlk İş")
        }
        
        // Marriage
        if character.relationshipStatus == .married && !character.achievements.contains("Evlendi") {
            character.achievements.append("Evlendi")
        }
        
        // First child
        if !character.children.isEmpty && !character.achievements.contains("İlk Çocuk") {
            character.achievements.append("İlk Çocuk")
        }
    }
    
    private func triggerRandomEvent() {
        let events: [(title: String, description: String, effects: (inout Character) -> Void)] = [
            ("Hasta Oldun", "Grip geçirdin", { $0.health = self.clamp($0.health - 5) }),
            ("Kazandın!", "Küçük bir piyango kazandın", { $0.money += 1000; $0.happiness = self.clamp($0.happiness + 5) }),
            ("Arkadaş Buldun", "Yeni bir arkadaş edindin", { $0.network = self.clamp($0.network + 3); $0.happiness = self.clamp($0.happiness + 2) }),
            ("Hastalandın", "Ciddi bir hastalık geçirdin", { $0.health = self.clamp($0.health - 15); $0.money = max(0, $0.money - 2000) }),
            ("Şanslı Gün", "Bugün çok şanslısın", { $0.luck = self.clamp($0.luck + 5); $0.money += 500 }),
            ("Kaza", "Küçük bir kaza geçirdin", { $0.health = self.clamp($0.health - 10); $0.money = max(0, $0.money - 1500) }),
            ("Hediye", "Beklenmedik bir hediye aldın", { $0.happiness = self.clamp($0.happiness + 5); $0.money += 300 }),
        ]
        
        if let event = events.randomElement() {
            event.effects(&character)
            var impact: String?
            if event.title.contains("Kazandın") || event.title.contains("Hediye") {
                impact = "Para +\(event.title.contains("Kazandın") ? "1000" : "300")"
            } else if event.title.contains("Hasta") || event.title.contains("Kaza") {
                impact = "Sağlık -\(event.title.contains("Hasta Oldun") ? "5" : "10")"
            }
            
            lifeLog.insert(
                LifeEvent(age: character.age, title: event.title, choice: event.description, impact: impact, kind: .random),
                at: 0
            )
        }
    }
    
    private func offerFirstJob() {
        let firstJobs = ["Kasiyer", "Garson", "Temizlikçi", "Güvenlik", "Çağrı Merkezi"]
        let job = firstJobs.randomElement() ?? "Kasiyer"
        character.jobTitle = job
        character.salary = 20000 + Int.random(in: 0...10000)
        character.incomePower = clamp(character.incomePower + 3)
        
        lifeLog.insert(
            LifeEvent(age: character.age, title: "İlk İşin!", choice: "\(job) olarak işe başladın", impact: "Maaş: ₺\(character.salary)", kind: .career),
            at: 0
        )
    }
    
    private func tryCareerProgression() {
        guard let currentJob = character.jobTitle else { return }
        
        let progressionChance = Double(character.smarts + character.reputation) / 200.0
        
        if Bool.random(probability: progressionChance) {
            let newJob = getNextJobLevel(currentJob: currentJob)
            character.jobTitle = newJob
            character.salary = calculateSalary(for: newJob)
            character.incomePower = clamp(character.incomePower + 5)
            
            lifeLog.insert(
                LifeEvent(age: character.age, title: "Terfi Aldın!", choice: "Yeni pozisyon: \(newJob)", impact: "Maaş artışı", kind: .career),
                at: 0
            )
        }
    }
    
    private func getNextJobLevel(currentJob: String) -> String {
        let careerPaths: [String: [String]] = [
            "Junior": ["Mid-level", "Senior", "Lead"],
            "Mid-level": ["Senior", "Lead", "Manager"],
            "Senior": ["Lead", "Manager", "Director"],
            "Lead": ["Manager", "Director", "VP"],
            "Manager": ["Director", "VP", "C-Level"],
            "Director": ["VP", "C-Level"],
            "VP": ["C-Level"],
        ]
        
        return careerPaths[currentJob]?.randomElement() ?? "Senior"
    }
    
    private func calculateSalary(for job: String) -> Int {
        let baseSalaries: [String: Int] = [
            "Junior": 30000,
            "Mid-level": 50000,
            "Senior": 80000,
            "Lead": 120000,
            "Manager": 150000,
            "Director": 200000,
            "VP": 300000,
            "C-Level": 500000,
        ]
        
        let base = baseSalaries[job] ?? 30000
        let modifier = Int(Double(base) * (Double(character.incomePower) / 100.0))
        return base + modifier
    }
    
    private func tryRelationshipEvent() {
        if character.relationshipStatus == .single && character.age >= 16 {
            if Bool.random(probability: 0.3) {
                let partnerNames = ["Alex", "Sam", "Jordan", "Taylor", "Casey", "Morgan", "Riley"]
                let partnerName = partnerNames.randomElement() ?? "Partner"
                
                character.relationshipStatus = .dating
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Yeni İlişki", choice: "\(partnerName) ile çıkmaya başladın", impact: "Mutluluk +5", kind: .relationship),
                    at: 0
                )
                character.happiness = clamp(character.happiness + 5)
            }
        } else if character.relationshipStatus == .dating {
            // Chance to get married
            if character.age >= 18 && Bool.random(probability: 0.2) {
                let spouseName = character.spouse?.name ?? "Partner"
                character.relationshipStatus = .married
                
                if character.spouse == nil {
                    character.spouse = Spouse(
                        name: spouseName,
                        age: character.age + Int.random(in: -3...3),
                        gender: ["Kadın", "Erkek", "Non-binary"].randomElement() ?? "Kadın",
                        occupation: nil,
                        relationshipQuality: 70 + Int.random(in: -10...10),
                        yearsTogether: 0
                    )
                }
                
                lifeLog.insert(
                    LifeEvent(age: character.age, title: "Evlendin!", choice: "\(spouseName) ile evlendin", impact: "Mutluluk +10", kind: .relationship),
                    at: 0
                )
                character.happiness = clamp(character.happiness + 10)
            }
        } else if character.relationshipStatus == .married, character.spouse != nil {
            // Chance to have children
            if character.age >= 20 && character.age <= 45 && character.children.count < 5 {
                if Bool.random(probability: 0.15) {
                    let childNames = ["Aydın", "Deniz", "Ege", "Lara", "Aras", "Mira", "Baran", "Rüya"]
                    let childName = childNames.randomElement() ?? "Çocuk"
                    
                    let child = Child(
                        name: childName,
                        age: 0,
                        gender: ["Kadın", "Erkek", "Non-binary"].randomElement() ?? "Kadın",
                        relationshipQuality: 80
                    )
                    
                    character.children.append(child)
                    lifeLog.insert(
                        LifeEvent(age: character.age, title: "Çocuğun Oldu!", choice: "\(childName) dünyaya geldi", impact: "Mutluluk +15", kind: .relationship),
                        at: 0
                    )
                    character.happiness = clamp(character.happiness + 15)
                }
            }
        }
    }
}

extension GameViewModel {
    static let activityPool: [Activity] = [
        Activity(
            title: "Mahalle Parkı",
            summary: "Parkta iki saat geçir, yeni insanlarla tanış.",
            category: .social,
            minAge: 5,
            maxAge: 25,
            weight: 3,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: nil,
                beautyChange: 1,
                luckChange: nil,
                auraChange: 2,
                educationPrestigeChange: nil,
                networkChange: 2,
                reputationChange: 1,
                incomePowerChange: nil,
                setCareerPath: nil,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Çevrimiçi Kurs",
            summary: "Ücretsiz bir STEM kursunu bitir.",
            category: .education,
            minAge: 12,
            maxAge: 40,
            weight: 3,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: 3,
                beautyChange: nil,
                luckChange: nil,
                auraChange: nil,
                educationPrestigeChange: 4,
                networkChange: 1,
                reputationChange: 1,
                incomePowerChange: 2,
                setCareerPath: .stem,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Gönüllü Destek",
            summary: "LGBTİ+ dayanışma merkezinde gönüllü ol.",
            category: .activism,
            minAge: 15,
            maxAge: 50,
            weight: 2,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: 0,
                beautyChange: nil,
                luckChange: -1,
                auraChange: 3,
                educationPrestigeChange: nil,
                networkChange: 3,
                reputationChange: 4,
                incomePowerChange: nil,
                setCareerPath: .social,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Yan İş",
            summary: "Haftasonu freelance iş yap.",
            category: .finance,
            minAge: 16,
            maxAge: 55,
            weight: 3,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: 1,
                beautyChange: nil,
                luckChange: 1,
                auraChange: nil,
                educationPrestigeChange: nil,
                networkChange: 1,
                reputationChange: 1,
                incomePowerChange: 4,
                setCareerPath: .business,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Spor/Move",
            summary: "Koşu kulübüne katıl.",
            category: .health,
            minAge: 10,
            maxAge: 70,
            weight: 2,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: nil,
                beautyChange: 2,
                luckChange: 1,
                auraChange: 2,
                educationPrestigeChange: nil,
                networkChange: 2,
                reputationChange: 1,
                incomePowerChange: nil,
                setCareerPath: nil,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Mentor Buluşması",
            summary: "Sektörden biriyle kahve sohbeti.",
            category: .career,
            minAge: 18,
            maxAge: 50,
            weight: 2,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: 1,
                beautyChange: nil,
                luckChange: 1,
                auraChange: 1,
                educationPrestigeChange: 2,
                networkChange: 4,
                reputationChange: 2,
                incomePowerChange: 2,
                setCareerPath: nil,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Aile Ziyareti",
            summary: "Aile büyüklerini ziyaret et, bağları onar.",
            category: .social,
            minAge: 8,
            maxAge: 70,
            weight: 2,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: nil,
                beautyChange: nil,
                luckChange: nil,
                auraChange: 1,
                educationPrestigeChange: nil,
                networkChange: 1,
                reputationChange: 2,
                incomePowerChange: 1,
                setCareerPath: nil,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Sertifika Programı",
            summary: "Prestijli bir kısa program için borca gir.",
            category: .education,
            minAge: 19,
            maxAge: 45,
            weight: 1,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: 2,
                beautyChange: nil,
                luckChange: -1,
                auraChange: 1,
                educationPrestigeChange: 6,
                networkChange: 3,
                reputationChange: 3,
                incomePowerChange: 3,
                setCareerPath: .business,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        ),
        Activity(
            title: "Bar Gece Hayatı",
            summary: "Yeni insanlarla tanış, bazıları fırsat bazıları risk.",
            category: .leisure,
            minAge: 18,
            maxAge: 45,
            weight: 2,
            requirements: nil,
            effect: CharacterEffect(
                intelligenceChange: -1,
                beautyChange: 2,
                luckChange: 2,
                auraChange: 3,
                educationPrestigeChange: nil,
                networkChange: 2,
                reputationChange: -1,
                incomePowerChange: nil,
                setCareerPath: nil,
                healthChange: nil,
                happinessChange: nil,
                smartsChange: nil,
                looksChange: nil,
                moneyChange: nil,
                setEducation: nil,
                setRelationship: nil,
                setJobTitle: nil
            )
        )
    ]
}
