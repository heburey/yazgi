import Foundation

struct FamilyGenerator {
    // MARK: - Country Income Weights for fixing CharacterCreationView error
    static let incomeWeightsByCountry: [String: [IncomeLevel: Double]] = [
        "Türkiye": [
            .veryLow: 0.15,
            .low: 0.25,
            .lowerMiddle: 0.25,
            .upperMiddle: 0.20,
            .high: 0.10,
            .veryHigh: 0.05
        ],
        "ABD": [
            .veryLow: 0.10,
            .low: 0.15,
            .lowerMiddle: 0.20,
            .upperMiddle: 0.30,
            .high: 0.15,
            .veryHigh: 0.10
        ],
        "Almanya": [
            .veryLow: 0.08,
            .low: 0.12,
            .lowerMiddle: 0.25,
            .upperMiddle: 0.35,
            .high: 0.15,
            .veryHigh: 0.05
        ],
        "Fransa": [
            .veryLow: 0.10,
            .low: 0.15,
            .lowerMiddle: 0.25,
            .upperMiddle: 0.30,
            .high: 0.15,
            .veryHigh: 0.05
        ],
        "İngiltere": [
            .veryLow: 0.12,
            .low: 0.18,
            .lowerMiddle: 0.25,
            .upperMiddle: 0.25,
            .high: 0.15,
            .veryHigh: 0.05
        ]
    ]
    
    static func generateFamily(culturalProfile: CulturalProfile) -> FamilyBackground {
        // Ebeveynleri oluştur
        let parents = generateParents(culturalProfile: culturalProfile)
        
        // Kardeşleri oluştur (0-3 arası)
        let siblingCount = Int.random(in: 0...3)
        let siblings = (0..<siblingCount).map { _ in
            generateSibling(culturalProfile: culturalProfile)
        }
        
        // Geniş aileyi oluştur (2-5 arası)
        let extendedFamilyCount = Int.random(in: 2...5)
        let extendedFamily = (0..<extendedFamilyCount).map { _ in
            generateExtendedFamilyMember(culturalProfile: culturalProfile)
        }
        
        // Aile servetini belirle
        let familyWealth = generateFamilyWealth()
        
        // Aile itibarını belirle (50-100 arası)
        let familyReputation = Int.random(in: 50...100)
        
        // Aile geleneklerini oluştur
        let familyTraditions = generateFamilyTraditions(culturalProfile: culturalProfile)
        
        // Aile değerlerini oluştur
        let familyValues = generateFamilyValues(culturalProfile: culturalProfile)
        
        // Aile dinamiklerini belirle
        let familyDynamics = generateFamilyDynamics()
        
        // Kalıtsal özellikleri belirle
        let inheritedTraits = generateInheritedTraits()
        
        // Çocukluk anılarını oluştur
        let childhoodMemories = generateChildhoodMemories()
        
        return FamilyBackground(
            parents: parents,
            siblings: siblings,
            extendedFamily: extendedFamily,
            familyWealth: familyWealth,
            familyReputation: familyReputation,
            familyTraditions: familyTraditions,
            familyValues: familyValues,
            familyDynamics: familyDynamics,
            familyTrauma: nil,
            inheritedTraits: inheritedTraits,
            childhoodMemories: childhoodMemories,
            familySecrets: nil
        )
    }
    
    private static func generateParents(culturalProfile: CulturalProfile) -> [Parent] {
        let parentCount = Int.random(in: 1...2)
        return (0..<parentCount).map { index in
            let isFirstParent = index == 0
            let gender = isFirstParent ? "Erkek" : "Kadın"
            let name = isFirstParent ? 
                culturalProfile.namePatterns.maleFirstNames.randomElement()! :
                culturalProfile.namePatterns.femaleFirstNames.randomElement()!
            
            return Parent(
                name: name,
                age: Int.random(in: 35...60),
                isAlive: true,
                occupation: culturalProfile.careerProfile.commonJobs.randomElement(),
                education: generateEducationLevel(),
                relationship: Int.random(in: 60...100),
                influence: Int.random(in: 50...100),
                supportLevel: Int.random(in: 70...100),
                personalityTraits: generatePersonalityTraits(),
                expectations: generateParentExpectations(),
                memories: generateParentMemories()
            )
        }
    }
    
    private static func generateSibling(culturalProfile: CulturalProfile) -> Sibling {
        let gender = Bool.random() ? "Erkek" : "Kadın"
        let name = gender == "Erkek" ?
            culturalProfile.namePatterns.maleFirstNames.randomElement()! :
            culturalProfile.namePatterns.femaleFirstNames.randomElement()!
        
        return Sibling(
            name: name,
            age: Int.random(in: 5...25),
            gender: gender,
            relationship: Int.random(in: 50...100),
            rivalry: Int.random(in: 0...70),
            supportLevel: Int.random(in: 60...100),
            occupation: nil,
            education: generateEducationLevel(),
            personalityTraits: generatePersonalityTraits(),
            sharedMemories: generateSiblingMemories()
        )
    }
    
    private static func generateExtendedFamilyMember(culturalProfile: CulturalProfile) -> ExtendedFamilyMember {
        let relations = ["Grandmother", "Grandfather", "Aunt", "Uncle", "Cousin"]
        let relation = relations.randomElement()!
        let gender = relation == "Grandmother" || relation == "Aunt" ? "Kadın" : "Erkek"
        let name = gender == "Erkek" ?
            culturalProfile.namePatterns.maleFirstNames.randomElement()! :
            culturalProfile.namePatterns.femaleFirstNames.randomElement()!
        
        return ExtendedFamilyMember(
            name: name,
            relation: relation,
            age: Int.random(in: 30...80),
            isAlive: true,
            relationship: Int.random(in: 40...100),
            influence: Int.random(in: 30...80),
            supportLevel: Int.random(in: 50...100),
            occupation: culturalProfile.careerProfile.commonJobs.randomElement(),
            personalityTraits: generatePersonalityTraits(),
            memories: generateExtendedFamilyMemories()
        )
    }
    
    private static func generateEducationLevel() -> EducationLevel {
        let levels: [EducationLevel] = [.none, .primary, .highSchool, .bachelor, .master, .phd]
        let weights = [0.1, 0.2, 0.3, 0.25, 0.1, 0.05]
        
        var random = Double.random(in: 0...1)
        for (index, weight) in weights.enumerated() {
            random -= weight
            if random <= 0 {
                return levels[index]
            }
        }
        return .highSchool
    }
    
    private static func generateFamilyWealth() -> SocioeconomicStatus {
        let statuses: [SocioeconomicStatus] = [.poverty, .workingClass, .lowerMiddleClass, .middleClass, .upperMiddleClass, .wealthy, .elite]
        let weights = [0.05, 0.15, 0.25, 0.3, 0.15, 0.08, 0.02]
        
        var random = Double.random(in: 0...1)
        for (index, weight) in weights.enumerated() {
            random -= weight
            if random <= 0 {
                return statuses[index]
            }
        }
        return .middleClass
    }
    
    private static func generateFamilyTraditions(culturalProfile: CulturalProfile) -> [String] {
        let commonTraditions = [
            "Bayram ziyaretleri",
            "Pazar kahvaltıları",
            "Yaz tatilleri",
            "Aile yemekleri",
            "Dini kutlamalar",
            "Yılbaşı kutlamaları",
            "Doğum günü partileri",
            "Piknikler",
            "Akraba ziyaretleri",
            "Kültürel festivaller"
        ]
        
        let traditionCount = Int.random(in: 3...6)
        return Array(commonTraditions.shuffled().prefix(traditionCount))
    }
    
    private static func generateFamilyValues(culturalProfile: CulturalProfile) -> [String] {
        let commonValues = [
            "Eğitim",
            "Dürüstlük",
            "Aile bağları",
            "Çalışkanlık",
            "Saygı",
            "Gelenekler",
            "Yardımlaşma",
            "Başarı",
            "Maneviyat",
            "Hoşgörü"
        ]
        
        let valueCount = Int.random(in: 3...6)
        return Array(commonValues.shuffled().prefix(valueCount))
    }
    
    private static func generateFamilyDynamics() -> FamilyDynamics {
        let dynamics: [FamilyDynamics] = [.supportive, .controlling, .distant, .chaotic, .balanced, .toxic, .overprotective, .neglectful]
        let weights = [0.3, 0.15, 0.1, 0.1, 0.2, 0.05, 0.07, 0.03]
        
        var random = Double.random(in: 0...1)
        for (index, weight) in weights.enumerated() {
            random -= weight
            if random <= 0 {
                return dynamics[index]
            }
        }
        return .balanced
    }
    
    private static func generatePersonalityTraits() -> [String] {
        let commonTraits = [
            "Anlayışlı",
            "Çalışkan",
            "Sabırlı",
            "Şefkatli",
            "Zeki",
            "Disiplinli",
            "Neşeli",
            "Sportif",
            "Yaratıcı",
            "Düzenli",
            "Sorumluluk sahibi",
            "Yardımsever",
            "Lider ruhlu",
            "Merhametli",
            "Sosyal"
        ]
        
        let traitCount = Int.random(in: 2...4)
        return Array(commonTraits.shuffled().prefix(traitCount))
    }
    
    private static func generateParentExpectations() -> [String] {
        let commonExpectations = [
            "Akademik başarı",
            "Dürüstlük",
            "Saygılı olma",
            "Kariyer",
            "Aile değerlerine bağlılık",
            "Sorumluluk sahibi olma",
            "Başarılı bir meslek",
            "İyi bir evlilik",
            "Sağlıklı yaşam",
            "Finansal bağımsızlık"
        ]
        
        let expectationCount = Int.random(in: 2...4)
        return Array(commonExpectations.shuffled().prefix(expectationCount))
    }
    
    private static func generateParentMemories() -> [Memory] {
        let commonMemories = [
            "Birlikte balık tutmaya gitmiştik",
            "İlk bisikletimi aldığımız gün",
            "Okul başarımı kutladığımız akşam",
            "Hasta olduğumda başımda beklediği geceler",
            "Birlikte yaptığımız ilk yemek",
            "Bana hayat dersleri verdiği uzun sohbetler",
            "İlk kez denize girdiğimiz gün",
            "Bayram sabahları birlikte hazırlanmamız",
            "Karne günü beni ödüllendirmesi",
            "Zor zamanlarımda yanımda olması"
        ]
        
        let memoryCount = Int.random(in: 1...3)
        return commonMemories.shuffled().prefix(memoryCount).map { description in
            Memory(
                title: description,
                description: description,
                date: Calendar.current.date(byAdding: .year, value: -Int.random(in: 5...15), to: Date())!,
                emotionalImpact: Int.random(in: 5...10),
                people: ["Anne", "Baba"],
                location: "Ev",
                tags: ["aile"],
                importance: Int.random(in: 5...10),
                type: MemoryType.family
            )
        }
    }
    
    private static func generateSiblingMemories() -> [Memory] {
        let commonMemories = [
            "Birlikte oyun oynadığımız yaz tatili",
            "Okul yolunda yaşadığımız maceralar",
            "Gizlice şeker yediğimiz zamanlar",
            "Birbirimize sırlarımızı anlattığımız geceler",
            "Kavga edip barıştığımız günler",
            "Birlikte televizyon izlediğimiz akşamlar",
            "Bahçede oynadığımız oyunlar",
            "Birbirimize yardım ettiğimiz dersler",
            "Paylaştığımız odadaki anılar",
            "Birlikte katıldığımız aile etkinlikleri"
        ]
        
        let memoryCount = Int.random(in: 1...3)
        return commonMemories.shuffled().prefix(memoryCount).map { description in
            Memory(
                title: description,
                description: description,
                date: Calendar.current.date(byAdding: .year, value: -Int.random(in: 2...10), to: Date())!,
                emotionalImpact: Int.random(in: 5...10),
                people: ["Kardeş"],
                location: "Ev",
                tags: ["aile", "kardeş"],
                importance: Int.random(in: 5...10),
                type: MemoryType.family
            )
        }
    }
    
    private static func generateExtendedFamilyMemories() -> [Memory] {
        let commonMemories = [
            "Bana masal anlattığı akşamlar",
            "Birlikte yaptığımız tatlılar",
            "Bayram harçlığı verdiği zamanlar",
            "Evindeki misafirlikler",
            "Bana hediye aldığı günler",
            "Aile toplantılarındaki sohbetler",
            "Yazlıktaki güzel günler",
            "Özel günlerdeki kutlamalar",
            "Birlikte çıktığımız geziler",
            "Bana öğrettiği geleneksel oyunlar"
        ]
        
        let memoryCount = Int.random(in: 1...3)
        return commonMemories.shuffled().prefix(memoryCount).map { description in
            Memory(
                title: description,
                description: description,
                date: Calendar.current.date(byAdding: .year, value: -Int.random(in: 3...12), to: Date())!,
                emotionalImpact: Int.random(in: 5...10),
                people: ["Büyükanne", "Büyükbaba"],
                location: "Büyükanne evi",
                tags: ["aile", "geniş aile"],
                importance: Int.random(in: 5...10),
                type: MemoryType.family
            )
        }
    }
    
    private static func generateInheritedTraits() -> [String] {
        let commonTraits = [
            "Analitik düşünce",
            "Empati",
            "Liderlik",
            "Yaratıcılık",
            "Müzik yeteneği",
            "Sportif yetenek",
            "Sosyal beceriler",
            "Pratik zeka",
            "Sanatsal yetenek",
            "Dil öğrenme yeteneği",
            "Problem çözme",
            "Organizasyon becerisi",
            "İletişim yeteneği",
            "Duygusal zeka",
            "Girişimcilik ruhu"
        ]
        
        let traitCount = Int.random(in: 2...4)
        return Array(commonTraits.shuffled().prefix(traitCount))
    }
    
    private static func generateChildhoodMemories() -> [Memory] {
        let commonMemories = [
            "İlk okul günüm",
            "İlk bisikletim",
            "Aile tatilimiz",
            "Doğum günü partim",
            "İlk evcil hayvanım",
            "Mahalle arkadaşlarımla oyunlar",
            "Dedemin anlattığı masallar",
            "Annemin yaptığı yemekler",
            "Bayram sabahları",
            "Karne günü kutlamaları",
            "Yaz tatillerindeki maceralar",
            "İlk başarı ödülüm",
            "Aile pikniklerimiz",
            "Kardeşimin doğumu",
            "İlk yurtdışı seyahatim"
        ]
        
        let memoryCount = Int.random(in: 3...6)
        return commonMemories.shuffled().prefix(memoryCount).map { description in
            Memory(
                title: description,
                description: description,
                date: Calendar.current.date(byAdding: .year, value: -Int.random(in: 5...15), to: Date())!,
                emotionalImpact: Int.random(in: 5...10),
                people: ["Aile"],
                location: "Ev/Okul",
                tags: ["çocukluk", "aile"],
                importance: Int.random(in: 5...10),
                type: MemoryType.family
            )
        }
    }
}

extension Bool {
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}
