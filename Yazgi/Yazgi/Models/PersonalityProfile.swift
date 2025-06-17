import Foundation

struct PersonalityProfile: Codable {
    // MARK: - Core Personality
    var personalityType: PersonalityType
    var traits: [PersonalityTrait]
    var characteristics: [String: Int] // 0-100 scale
    var culturalAdaptation: Int // 0-100 scale for adaptation to cultural values
    
    // MARK: - Demographics & Identity
    var sexualOrientation: SexualOrientation
    var politicalAlignment: PoliticalAlignment
    var genderIdentity: String?
    var religiousAffiliation: ReligiousAffiliation
    var culturalIdentity: [String: Double] // Multiple cultural influences
    var neurodivergence: [Neurodivergence]
    
    // MARK: - Behavioral Patterns
    var communicationStyle: String
    var conflictResolution: String
    var decisionMaking: String
    var stressCoping: String
    var socialBattery: Int // 0-100, how much social interaction energizes vs drains
    
    // MARK: - Values & Beliefs
    var coreValues: [String]
    var politicalBeliefs: [String]
    var religiousBeliefs: [String]
    var personalBeliefs: [String]
    
    // MARK: - Computed Properties
    var isIntrovert: Bool {
        guard let extraversion = characteristics["extraversion"] else { return false }
        return extraversion < 50
    }
    
    var isEmotionallyStable: Bool {
        guard let neuroticism = characteristics["neuroticism"] else { return true }
        return neuroticism < 30
    }
    
    var isOpenToExperience: Bool {
        guard let openness = characteristics["openness"] else { return false }
        return openness > 70
    }
    
    // MARK: - Personality Generation
    static func generateRandom() -> PersonalityProfile {
        let randomType = PersonalityType.allCases.randomElement() ?? .INFP
        let randomTraits = PersonalityTrait.generateRandomSet()
        
        return PersonalityProfile(
            personalityType: randomType,
            traits: randomTraits,
            characteristics: generateRandomCharacteristics(),
            culturalAdaptation: Int.random(in: 30...90),
            sexualOrientation: SexualOrientation.allCases.randomElement() ?? .heterosexual,
            politicalAlignment: PoliticalAlignment.allCases.randomElement() ?? .center,
            genderIdentity: nil,
            religiousAffiliation: ReligiousAffiliation.allCases.randomElement() ?? .agnostic,
            culturalIdentity: [:],
            neurodivergence: generateRandomNeurodivergence(),
            communicationStyle: "Direct",
            conflictResolution: "Collaborative",
            decisionMaking: "Analytical",
            stressCoping: "Problem-solving",
            socialBattery: Int.random(in: 20...80),
            coreValues: ["Honesty", "Family", "Achievement"],
            politicalBeliefs: [],
            religiousBeliefs: [],
            personalBeliefs: []
        )
    }
    
    private static func generateRandomCharacteristics() -> [String: Int] {
        return [
            "extraversion": Int.random(in: 0...100),
            "agreeableness": Int.random(in: 0...100),
            "conscientiousness": Int.random(in: 0...100),
            "neuroticism": Int.random(in: 0...100),
            "openness": Int.random(in: 0...100)
        ]
    }
    
    private static func generateRandomNeurodivergence() -> [Neurodivergence] {
        let chance = Double.random(in: 0...1)
        if chance < 0.8 {
            return [.none]
        } else {
            let allCases = Neurodivergence.allCases.filter { $0 != .none }
            return [allCases.randomElement() ?? .none]
        }
    }
    
    static func generateCompatible(with cultural: CulturalProfile) -> PersonalityProfile {
        var profile = generateRandom()
        
        // Adjust based on cultural values
        let culturalValues = cultural.culturalValues
        
        // Higher cultural adaptation for traditional cultures
        if cultural.educationProfile.system == .traditional {
            profile.culturalAdaptation = Int.random(in: 60...95)
        }
        
        return profile
    }
    
    // MARK: - Compatibility Calculation
    func calculateSocialCompatibility(with other: PersonalityProfile) -> Int {
        var compatibility = 50 // Base compatibility
        
        // Personality type compatibility
        compatibility += calculateTypeCompatibility(self.personalityType, other.personalityType)
        
        // Value alignment
        let sharedValues = Set(self.coreValues).intersection(Set(other.coreValues))
        compatibility += sharedValues.count * 5
        
        // Political alignment compatibility
        compatibility += calculatePoliticalCompatibility(self.politicalAlignment, other.politicalAlignment)
        
        // Communication style compatibility
        if self.communicationStyle == other.communicationStyle {
            compatibility += 10
        }
        
        return min(max(compatibility, 0), 100)
    }
    
    private func calculateTypeCompatibility(_ type1: PersonalityType, _ type2: PersonalityType) -> Int {
        // Simplified compatibility matrix
        let compatibilityMatrix: [PersonalityType: [PersonalityType: Int]] = [
            .INFP: [.ENFJ: 15, .INTJ: 10, .INFP: 5],
            .ENFJ: [.INFP: 15, .INTJ: 10, .ENFJ: 5],
            .INTJ: [.ENFP: 12, .INFP: 10, .INTJ: 5]
        ]
        
        return compatibilityMatrix[type1]?[type2] ?? 0
    }
    
    private func calculatePoliticalCompatibility(_ pol1: PoliticalAlignment, _ pol2: PoliticalAlignment) -> Int {
        let distance = abs(getPoliticalValue(pol1) - getPoliticalValue(pol2))
        return max(0, 15 - distance * 3)
    }
    
    private func getPoliticalValue(_ alignment: PoliticalAlignment) -> Int {
        switch alignment {
        case .farLeft: return 0
        case .left: return 1
        case .centerLeft: return 2
        case .center: return 3
        case .centerRight: return 4
        case .right: return 5
        case .farRight: return 6
        case .apolitical: return 3 // Neutral
        }
    }
}

// Extensions for missing cases
extension PersonalityType: CaseIterable {
    public static var allCases: [PersonalityType] = [
        .INTJ, .INTP, .ENTJ, .ENTP,
        .INFJ, .INFP, .ENFJ, .ENFP,
        .ISTJ, .ISFJ, .ESTJ, .ESFJ,
        .ISTP, .ISFP, .ESTP, .ESFP
    ]
}

extension SexualOrientation: CaseIterable {
    public static var allCases: [SexualOrientation] = [
        .heterosexual, .homosexual, .bisexual, .pansexual, .asexual, .questioning
    ]
}

extension PoliticalAlignment: CaseIterable {
    public static var allCases: [PoliticalAlignment] = [
        .farLeft, .left, .centerLeft, .center, .centerRight, .right, .farRight, .apolitical
    ]
}

extension ReligiousAffiliation: CaseIterable {
    public static var allCases: [ReligiousAffiliation] = [
        .muslim, .christian, .jewish, .buddhist, .hindu, .atheist, .agnostic, .spiritual, .other
    ]
}

extension Neurodivergence: CaseIterable {
    public static var allCases: [Neurodivergence] = [
        .none, .adhd, .autism, .dyslexia, .anxiety, .depression, .ocd, .bipolar, .other
    ]
}

extension PersonalityTrait {
    static func generateRandomSet() -> [PersonalityTrait] {
        let traitNames = ["Optimistic", "Analytical", "Creative", "Empathetic", "Ambitious"]
        return traitNames.map { name in
            PersonalityTrait(
                name: name,
                description: "A \(name.lowercased()) personality trait",
                intensity: Int.random(in: 3...8),
                effects: [],
                category: .personality
            )
        }
    }
}

// MARK: - Preview Helper
extension PersonalityProfile {
    static var preview: PersonalityProfile {
        PersonalityProfile(
            personalityType: .INFP,
            traits: PersonalityTrait.generateRandomSet(),
            characteristics: [
                "extraversion": 30,
                "agreeableness": 80,
                "conscientiousness": 70,
                "neuroticism": 40,
                "openness": 85
            ],
            culturalAdaptation: 75,
            sexualOrientation: .heterosexual,
            politicalAlignment: .centerLeft,
            genderIdentity: nil,
            religiousAffiliation: .spiritual,
            culturalIdentity: ["Turkish": 1.0],
            neurodivergence: [.none],
            communicationStyle: "Empathetic",
            conflictResolution: "Collaborative",
            decisionMaking: "Value-based",
            stressCoping: "Creative Expression",
            socialBattery: 45,
            coreValues: ["Authenticity", "Creativity", "Harmony", "Personal Growth"],
            politicalBeliefs: ["Social Justice", "Environmental Protection"],
            religiousBeliefs: ["Personal Spirituality"],
            personalBeliefs: ["Everyone has inherent worth", "Growth comes through challenges"]
        )
    }
} 