import Foundation

struct FamilyBackground: Codable {
    var parents: [Parent]
    var siblings: [Sibling]
    var extendedFamily: [ExtendedFamilyMember]
    var familyWealth: SocioeconomicStatus
    var familyReputation: Int
    var familyTraditions: [String]
    var familyValues: [String]
    var familyDynamics: FamilyDynamics
    var familyTrauma: String?
    var inheritedTraits: [String]
    var childhoodMemories: [Memory]
    var familySecrets: [String]?
    
    // Hesaplanan özellikler
    var familySize: Int {
        parents.count + siblings.count + extendedFamily.count
    }
    
    var familySupport: Int {
        let parentSupport = parents.reduce(0) { $0 + $1.supportLevel }
        let siblingSupport = siblings.reduce(0) { $0 + $1.supportLevel }
        let extendedSupport = extendedFamily.reduce(0) { $0 + $1.supportLevel }
        
        let totalPossibleSupport = (parents.count + siblings.count + extendedFamily.count) * 100
        let actualSupport = parentSupport + siblingSupport + extendedSupport
        
        return totalPossibleSupport > 0 ? (actualSupport * 100) / totalPossibleSupport : 0
    }
}

struct Parent: Codable {
    var name: String
    var age: Int
    var isAlive: Bool
    var occupation: String?
    var education: EducationLevel
    var relationship: Int // 0-100
    var influence: Int // 0-100
    var supportLevel: Int // 0-100
    var personalityTraits: [String]
    var expectations: [String]
    var memories: [Memory]
}

struct Sibling: Codable {
    var name: String
    var age: Int
    var gender: String
    var relationship: Int // 0-100
    var rivalry: Int // 0-100
    var supportLevel: Int // 0-100
    var occupation: String?
    var education: EducationLevel
    var personalityTraits: [String]
    var sharedMemories: [Memory]
}

struct ExtendedFamilyMember: Codable {
    var name: String
    var relation: String
    var age: Int
    var isAlive: Bool
    var relationship: Int // 0-100
    var influence: Int // 0-100
    var supportLevel: Int // 0-100
    var occupation: String?
    var personalityTraits: [String]
    var memories: [Memory]
}

enum FamilyDynamics: String, Codable {
    case supportive = "Destekleyici"
    case controlling = "Kontrolcü"
    case distant = "Mesafeli"
    case chaotic = "Kaotik"
    case balanced = "Dengeli"
    case toxic = "Toksik"
    case overprotective = "Aşırı Korumacı"
    case neglectful = "İhmalkar"
}

// MARK: - Preview Helper
extension FamilyBackground {
    static var preview: FamilyBackground {
        FamilyBackground(
            parents: [
                Parent(
                    name: "Mehmet Yılmaz",
                    age: 45,
                    isAlive: true,
                    occupation: "Öğretmen",
                    education: .bachelor,
                    relationship: 85,
                    influence: 70,
                    supportLevel: 90,
                    personalityTraits: ["Anlayışlı", "Çalışkan", "Sabırlı"],
                    expectations: ["Akademik başarı", "Dürüstlük"],
                    memories: [
                        Memory(
                            title: "Balık Tutma Anısı",
                            description: "Birlikte balık tutmaya gitmiştik",
                            date: Calendar.current.date(byAdding: .year, value: -5, to: Date())!,
                            emotionalImpact: 8,
                            people: ["Baba"],
                            location: "Göl kenarı",
                            tags: ["aile", "outdoor"],
                            importance: 8,
                            type: MemoryType.family
                        )
                    ]
                ),
                Parent(
                    name: "Ayşe Yılmaz",
                    age: 42,
                    isAlive: true,
                    occupation: "Doktor",
                    education: .doctorate,
                    relationship: 90,
                    influence: 75,
                    supportLevel: 95,
                    personalityTraits: ["Şefkatli", "Zeki", "Disiplinli"],
                    expectations: ["Sağlıklı yaşam", "Kariyer"],
                    memories: [
                        Memory(
                            title: "İlk Bisiklet",
                            description: "İlk bisikletimi aldığımız gün",
                            date: Calendar.current.date(byAdding: .year, value: -10, to: Date())!,
                            emotionalImpact: 9,
                            people: ["Anne"],
                            location: "Bisiklet mağazası",
                            tags: ["aile", "çocukluk"],
                            importance: 9,
                            type: MemoryType.family
                        )
                    ]
                )
            ],
            siblings: [
                Sibling(
                    name: "Can Yılmaz",
                    age: 15,
                    gender: "Erkek",
                    relationship: 80,
                    rivalry: 30,
                    supportLevel: 85,
                    occupation: nil,
                    education: .highSchool,
                    personalityTraits: ["Neşeli", "Sportif"],
                    sharedMemories: [
                        Memory(
                            title: "Yaz Tatili Oyunları",
                            description: "Birlikte oyun oynadığımız yaz tatili",
                            date: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
                            emotionalImpact: 7,
                            people: ["Kardeş"],
                            location: "Tatil evi",
                            tags: ["aile", "oyun"],
                            importance: 7,
                            type: MemoryType.family
                        )
                    ]
                )
            ],
            extendedFamily: [
                ExtendedFamilyMember(
                    name: "Fatma Demir",
                    relation: "Grandmother",
                    age: 70,
                    isAlive: true,
                    relationship: 95,
                    influence: 60,
                    supportLevel: 85,
                    occupation: "Emekli Öğretmen",
                    personalityTraits: ["Bilge", "Sevecen"],
                    memories: [
                        Memory(
                            title: "Büyükanne Masalları",
                            description: "Bana masal anlattığı akşamlar",
                            date: Calendar.current.date(byAdding: .year, value: -8, to: Date())!,
                            emotionalImpact: 8,
                            people: ["Büyükanne"],
                            location: "Büyükanne evi",
                            tags: ["aile", "masal"],
                            importance: 8,
                            type: MemoryType.family
                        )
                    ]
                )
            ],
            familyWealth: .middleClass,
            familyReputation: 85,
            familyTraditions: ["Bayram ziyaretleri", "Pazar kahvaltıları"],
            familyValues: ["Eğitim", "Dürüstlük", "Aile bağları"],
            familyDynamics: .supportive,
            familyTrauma: nil,
            inheritedTraits: ["Analitik düşünce", "Empati"],
            childhoodMemories: [
                Memory(
                    title: "İlk Okul Günü",
                    description: "İlk okul günüm",
                    date: Calendar.current.date(byAdding: .year, value: -12, to: Date())!,
                    emotionalImpact: 7,
                    people: ["Anne", "Baba"],
                    location: "Okul",
                    tags: ["eğitim", "ilk"],
                    importance: 7,
                    type: MemoryType.family
                )
            ],
            familySecrets: nil
        )
    }
}
