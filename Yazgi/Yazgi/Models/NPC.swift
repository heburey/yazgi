import Foundation

enum NPCType: String, Codable {
    case friend = "Arkadaş"
    case teacher = "Öğretmen"
    case neighbor = "Komşu"
    case classmate = "Sınıf Arkadaşı"
    case colleague = "İş Arkadaşı"
    case familyFriend = "Aile Dostu"
    case mentor = "Mentor"
    case rival = "Rakip"
    case bully = "Zorba"
    case loveInterest = "Gönül İlişkisi"
}

enum RelationshipDynamics: String, Codable {
    case friendly = "Arkadaşça"
    case romantic = "Romantik"
    case hostile = "Düşmanca"
    case neutral = "Nötr"
    case competitive = "Rekabetçi"
    case supportive = "Destekleyici"
    case toxic = "Toksik"
    case distant = "Mesafeli"
}

enum InteractionType: String, Codable {
    case conversation = "Sohbet"
    case activity = "Aktivite"
    case conflict = "Çatışma"
    case support = "Destek"
    case romance = "Romantik"
    case mentoring = "Mentorluk"
    case bullying = "Zorbalık"
    case collaboration = "İşbirliği"
}

struct NPC: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var type: NPCType
    var age: Int
    var gender: String
    var occupation: String?
    var personalityProfile: PersonalityProfile
    var culturalBackground: CulturalProfile
    
    // İlişki durumu
    var relationshipDynamic: RelationshipDynamics
    var relationshipStrength: Int // 0-100 arası
    var trustLevel: Int // 0-100 arası
    var influence: Int // 0-100 arası (karakterin hayatındaki etki gücü)
    
    // Etkileşim geçmişi
    var interactions: [Interaction]
    var sharedExperiences: [SharedExperience]
    var memories: [Memory]
    
    // Karakter üzerindeki etkileri
    var effects: [NPCEffect]
    
    // Dinamik özellikler
    var moodTowardsPlayer: Int // 0-100 arası
    var hasUnresolvedConflict: Bool
    var lastInteractionDate: Date?
    
    mutating func interact(_ interaction: Interaction) {
        interactions.append(interaction)
        lastInteractionDate = Date()
        updateRelationshipStrength(for: interaction)
        updateMood(for: interaction)
        
        if interaction.significance > 5 {
            memories.append(Memory(
                title: "Etkileşim Anısı",
                description: interaction.description,
                date: Date(),
                emotionalImpact: interaction.emotionalImpact,
                people: [name],
                location: interaction.location ?? "Bilinmeyen",
                tags: ["sosyal", "etkileşim"],
                importance: interaction.significance,
                type: MemoryType.social
            ))
        }
        
        if interaction.type == .conflict {
            hasUnresolvedConflict = true
        } else if interaction.type == .support && hasUnresolvedConflict {
            hasUnresolvedConflict = false
        }
    }
    
    private mutating func updateRelationshipStrength(for interaction: Interaction) {
        let impact = interaction.positiveImpact ? 2 : -2
        relationshipStrength = max(0, min(100, relationshipStrength + impact))
        
        if interaction.involvesTrust {
            let trustImpact = interaction.positiveImpact ? 3 : -5
            trustLevel = max(0, min(100, trustLevel + trustImpact))
        }
    }
    
    private mutating func updateMood(for interaction: Interaction) {
        let moodImpact = interaction.emotionalImpact
        moodTowardsPlayer = max(0, min(100, moodTowardsPlayer + moodImpact))
    }
    
    func calculateCompatibility(with character: Character) -> Double {
        var compatibility = 0.0
        
        // Kişilik uyumu
        compatibility += personalityProfile.calculateSocialCompatibility(with: character.personalityProfile)
        
        // Kültürel uyum
        if culturalBackground.countryCode == character.culturalBackground.countryCode {
            compatibility += 0.1
        }
        
        // Yaş uyumu
        let ageDifference = abs(Double(age - character.age))
        if ageDifference <= 5 {
            compatibility += 0.2
        } else if ageDifference <= 10 {
            compatibility += 0.1
        }
        
        return min(max(compatibility, 0.0), 1.0)
    }
}

struct Interaction: Identifiable, Codable {
    let id: UUID = UUID()
    let date: Date
    let type: InteractionType
    let description: String
    let location: String?
    let duration: TimeInterval
    let participants: [String]
    
    let positiveImpact: Bool
    let emotionalImpact: Int // -10 ile 10 arası
    let significance: Int // 1-10 arası
    let involvesTrust: Bool
    
    var outcomes: [String]
    var triggers: [String]?
}

struct SharedExperience: Identifiable, Codable {
    let id: UUID = UUID()
    let date: Date
    let type: String
    let description: String
    let location: String
    let duration: TimeInterval
    let emotionalSignificance: Int // 1-10 arası
    let photos: [String]?
}

// Using Memory from SharedTypes.swift to avoid conflict

struct NPCEffect: Codable {
    let attribute: String
    let magnitude: Int
    let duration: TimeInterval?
    let condition: String?
}

// MARK: - Preview Helper
extension NPC {
    static var preview: NPC {
        NPC(
            name: "Ayşe Yılmaz",
            type: .friend,
            age: 16,
            gender: "Kadın",
            occupation: "Öğrenci",
            personalityProfile: .preview,
            culturalBackground: .preview,
            relationshipDynamic: .friendly,
            relationshipStrength: 75,
            trustLevel: 80,
            influence: 60,
            interactions: [
                Interaction(
                    date: Date(),
                    type: .conversation,
                    description: "Okul kantininde sohbet",
                    location: "Okul Kantini",
                    duration: 1800, // 30 dakika
                    participants: ["Ayşe Yılmaz"],
                    positiveImpact: true,
                    emotionalImpact: 5,
                    significance: 6,
                    involvesTrust: false,
                    outcomes: ["Arkadaşlık güçlendi"]
                )
            ],
            sharedExperiences: [
                SharedExperience(
                    date: Date(),
                    type: "Okul Projesi",
                    description: "Biyoloji projesi hazırlığı",
                    location: "Okul Kütüphanesi",
                    duration: 7200, // 2 saat
                    emotionalSignificance: 7,
                    photos: nil
                )
            ],
            memories: [
                Memory(
                    title: "İlk Tanışma",
                    description: "İlk tanışma anı",
                    date: Date(),
                    emotionalImpact: 8,
                    people: ["Ayşe Yılmaz"],
                    location: "Okul",
                    tags: ["tanışma", "sosyal"],
                    importance: 8,
                    type: MemoryType.social
                )
            ],
            effects: [
                NPCEffect(
                    attribute: "confidence",
                    magnitude: 5,
                    duration: nil,
                    condition: nil
                )
            ],
            moodTowardsPlayer: 85,
            hasUnresolvedConflict: false,
            lastInteractionDate: Date()
        )
    }
}

// MARK: - NPC Prototypes
extension NPC {
    static let bullyPrototype = NPC(
        name: "Burak Yıldırım",
        type: .bully,
        age: 16,
        gender: "Erkek",
        occupation: "Öğrenci",
        personalityProfile: PersonalityProfile(
            mbti: .ESTP,
            bigFive: BigFive(
                openness: 30,
                conscientiousness: 40,
                extraversion: 85,
                agreeableness: 20,
                neuroticism: 70
            ),
            sexuality: .heterosexual,
            politicalView: .right,
            neurodivergence: nil,
            spirituality: .agnostic,
            values: PersonalValues(
                individualism: 80,
                traditionalism: 60,
                ambition: 85,
                hedonism: 90,
                powerOrientation: 95
            ),
            traits: [
                PersonalityTrait(name: "Dominant", level: 90),
                PersonalityTrait(name: "İmpulsif", level: 85),
                PersonalityTrait(name: "Rekabetçi", level: 80)
            ]
        ),
        culturalBackground: .turkiye,
        relationshipDynamic: .hostile,
        relationshipStrength: 20,
        trustLevel: 10,
        influence: 70,
        interactions: [
            Interaction(
                date: Date(),
                type: .bullying,
                description: "Okul koridorunda sözlü taciz",
                location: "Okul Koridoru",
                duration: 300,
                participants: ["Burak Yıldırım"],
                positiveImpact: false,
                emotionalImpact: -8,
                significance: 8,
                involvesTrust: false,
                outcomes: ["Özgüven kaybı", "Sosyal kaygı"],
                triggers: ["Okul korkusu", "Sosyal izolasyon"]
            )
        ],
        sharedExperiences: [],
        memories: [
            Memory(
                date: Date(),
                description: "İlk zorbalık deneyimi",
                emotionalImpact: -8,
                type: .bullying
            )
        ],
        effects: [
            NPCEffect(
                attribute: "self_confidence",
                magnitude: -20,
                duration: nil,
                condition: "school_environment"
            )
        ],
        moodTowardsPlayer: 30,
        hasUnresolvedConflict: true,
        lastInteractionDate: Date()
    )
    
    static let bestFriendPrototype = NPC(
        name: "Zeynep Kaya",
        type: .friend,
        age: 16,
        gender: "Kadın",
        occupation: "Öğrenci",
        personalityProfile: PersonalityProfile(
            mbti: .ENFJ,
            bigFive: BigFive(
                openness: 85,
                conscientiousness: 75,
                extraversion: 80,
                agreeableness: 90,
                neuroticism: 40
            ),
            sexuality: .heterosexual,
            politicalView: .centerLeft,
            neurodivergence: nil,
            spirituality: .spiritual,
            values: PersonalValues(
                individualism: 60,
                traditionalism: 40,
                ambition: 70,
                hedonism: 65,
                powerOrientation: 45
            ),
            traits: [
                PersonalityTrait(name: "Empati", level: 90),
                PersonalityTrait(name: "Sadakat", level: 95),
                PersonalityTrait(name: "İyimserlik", level: 85)
            ]
        ),
        culturalBackground: .turkiye,
        relationshipDynamic: .supportive,
        relationshipStrength: 95,
        trustLevel: 90,
        influence: 85,
        interactions: [
            Interaction(
                date: Date(),
                type: .support,
                description: "Zor zamanında duygusal destek",
                location: "Park",
                duration: 7200,
                participants: ["Zeynep Kaya"],
                positiveImpact: true,
                emotionalImpact: 9,
                significance: 9,
                involvesTrust: true,
                outcomes: ["Güven artışı", "Duygusal iyileşme"],
                triggers: ["Güçlü dostluk bağı", "Karşılıklı destek"]
            )
        ],
        sharedExperiences: [
            SharedExperience(
                date: Date(),
                type: "Tatil",
                description: "Yaz tatilinde kamp macerası",
                location: "Antalya",
                duration: 259200,
                emotionalSignificance: 9,
                photos: ["camp_1", "camp_2"]
            )
        ],
        memories: [
            Memory(
                date: Date(),
                description: "İlk tanışma anı",
                emotionalImpact: 8,
                type: .conversation
            )
        ],
        effects: [
            NPCEffect(
                attribute: "emotional_wellbeing",
                magnitude: 30,
                duration: nil,
                condition: nil
            )
        ],
        moodTowardsPlayer: 95,
        hasUnresolvedConflict: false,
        lastInteractionDate: Date()
    )
    
    static let inspiringTeacherPrototype = NPC(
        name: "Ayşe Öztürk",
        type: .teacher,
        age: 35,
        gender: "Kadın",
        occupation: "Edebiyat Öğretmeni",
        personalityProfile: PersonalityProfile(
            mbti: .INFJ,
            bigFive: BigFive(
                openness: 90,
                conscientiousness: 85,
                extraversion: 70,
                agreeableness: 85,
                neuroticism: 30
            ),
            sexuality: .heterosexual,
            politicalView: .centerLeft,
            neurodivergence: nil,
            spirituality: .spiritual,
            values: PersonalValues(
                individualism: 70,
                traditionalism: 50,
                ambition: 80,
                hedonism: 60,
                powerOrientation: 40
            ),
            traits: [
                PersonalityTrait(name: "İlham verici", level: 90),
                PersonalityTrait(name: "Anlayışlı", level: 85),
                PersonalityTrait(name: "Bilge", level: 80)
            ]
        ),
        culturalBackground: .turkiye,
        relationshipDynamic: .supportive,
        relationshipStrength: 80,
        trustLevel: 85,
        influence: 90,
        interactions: [
            Interaction(
                date: Date(),
                type: .mentoring,
                description: "Kariyer danışmanlığı görüşmesi",
                location: "Öğretmenler Odası",
                duration: 3600,
                participants: ["Ayşe Öztürk"],
                positiveImpact: true,
                emotionalImpact: 8,
                significance: 9,
                involvesTrust: true,
                outcomes: ["Kariyer hedefi netleşmesi", "Özgüven artışı"],
                triggers: ["Akademik motivasyon", "Kişisel gelişim"]
            )
        ],
        sharedExperiences: [
            SharedExperience(
                date: Date(),
                type: "Okul Projesi",
                description: "Edebiyat kulübü yıl sonu gösterisi",
                location: "Okul Salonu",
                duration: 14400,
                emotionalSignificance: 8,
                photos: ["literature_club_1"]
            )
        ],
        memories: [
            Memory(
                date: Date(),
                description: "İlk başarılı sunum",
                emotionalImpact: 9,
                type: .mentoring
            )
        ],
        effects: [
            NPCEffect(
                attribute: "academic_motivation",
                magnitude: 40,
                duration: nil,
                condition: "school_environment"
            ),
            NPCEffect(
                attribute: "self_confidence",
                magnitude: 30,
                duration: nil,
                condition: nil
            )
        ],
        moodTowardsPlayer: 85,
        hasUnresolvedConflict: false,
        lastInteractionDate: Date()
    )
} 