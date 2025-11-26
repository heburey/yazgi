import Foundation

struct FamilyGenerator {
    static func generateFamily(for country: String) -> FamilyBackground {
        let incomeWeights = incomeWeightsByCountry[country] ?? ["low", "medium", "medium", "high"]

        func randomIncome() -> IncomeLevel {
            incomeWeights.compactMap { IncomeLevel(rawValue: $0) }.randomElement() ?? .medium
        }

        let occupationByIncome: [IncomeLevel: [String]] = [
            .none: ["İşsiz", "Hasta", "Evde Bakım"],
            .low: ["Temizlikçi", "Güvenlik", "Şoför"],
            .medium: ["Öğretmen", "Hemşire", "Memur", "Teknisyen"],
            .high: ["Avukat", "Mühendis", "Yönetici"],
            .veryHigh: ["Doktor", "CEO", "Diplomat"]
        ]

        func randomOccupation(for level: IncomeLevel) -> String {
            occupationByIncome[level]?.randomElement() ?? "Bilinmeyen"
        }

        func generateParent(role: ParentRole) -> Parent {
            let known = Bool.random(probability: 0.85)
            let alive = Bool.random(probability: 0.9)
            let income = randomIncome()

            return Parent(
                name: known ? randomName(for: role) : nil,
                role: role,
                gender: genderFor(role: role),
                occupation: known ? randomOccupation(for: income) : nil,
                incomeLevel: known ? income : .none,
                isAlive: alive,
                deathCause: alive ? nil : [.illness, .accident, .war, .naturalCauses].randomElement(),
                isKnown: known
            )
        }

        var mother = generateParent(role: .mother)
        var father = generateParent(role: .father)

        while abs(score(for: mother.incomeLevel) - score(for: father.incomeLevel)) > 2 {
            father = generateParent(role: .father)
        }

        let isAdopted = Bool.random(probability: 0.05)
        let married = Bool.random(probability: 0.7)
        let divorced = !married && Bool.random(probability: 0.5)

        let maritalStatus: MaritalStatus = {
            if married { return .married }
            else if divorced { return .divorced }
            else { return .neverMarried }
        }()

        let hasPrenup = maritalStatus == .divorced ? Bool.random(probability: 0.3) : nil

        let custody: CustodyDecision? = {
            if maritalStatus == .divorced {
                let options: [CustodyDecision] = [.mother, .father, .shared, .courtDecided, .childChose]
                return options.randomElement()
            } else {
                return nil
            }
        }()

        return FamilyBackground(
            parents: [mother, father],
            maritalStatus: maritalStatus,
            hasPrenup: hasPrenup,
            isAdopted: isAdopted,
            custody: custody
        )
    }

    static func genderFor(role: ParentRole) -> String {
        switch role {
        case .mother: return "Kadın"
        case .father: return "Erkek"
        case .unknown: return "Bilinmeyen"
        }
    }

    static func randomName(for role: ParentRole) -> String {
        let femaleNames = ["Ayşe", "Fatma", "Elif", "Zeynep", "Lara"]
        let maleNames = ["Ahmet", "Mehmet", "Ali", "Burak", "Can"]

        switch role {
        case .mother: return femaleNames.randomElement() ?? "Anne"
        case .father: return maleNames.randomElement() ?? "Baba"
        case .unknown: return "Bilinmeyen"
        }
    }

    static func score(for income: IncomeLevel) -> Int {
        switch income {
        case .none: return 0
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .veryHigh: return 4
        }
    }

    static let incomeWeightsByCountry: [String: [String]] = [
        "Afganistan": ["low", "medium", "medium", "high"],
        "Almanya": ["low", "medium", "medium", "high"],
        "Amerika Birleşik Devletleri": ["low", "medium", "medium", "high"],
        "Andorra": ["low", "medium", "medium", "high"],
        "Angola": ["low", "medium", "medium", "high"],
        "Arjantin": ["low", "medium", "medium", "high"],
        "Avustralya": ["medium", "high", "veryHigh"],
        "Azerbaycan": ["low", "medium", "medium", "high"],
        "Bangladeş": ["low", "low", "medium"],
        "Belçika": ["medium", "high", "veryHigh"],
        "Brezilya": ["low", "medium", "medium", "high"],
        "Bulgaristan": ["low", "medium", "medium"],
        "Çin": ["low", "medium", "medium", "high", "veryHigh"],
        "Danimarka": ["medium", "high", "veryHigh"],
        "Fransa": ["medium", "medium", "high", "veryHigh"],
        "Hindistan": ["low", "low", "medium", "medium"],
        "İngiltere": ["medium", "high", "veryHigh"],
        "İran": ["low", "low", "medium"],
        "İsrail": ["medium", "high", "veryHigh"],
        "İsveç": ["medium", "high", "veryHigh", "veryHigh"],
        "İtalya": ["medium", "medium", "high"],
        "Japonya": ["medium", "high", "veryHigh"],
        "Kanada": ["medium", "high", "veryHigh"],
        "Meksika": ["low", "medium", "medium", "high"],
        "Norveç": ["high", "high", "veryHigh"],
        "Pakistan": ["none", "low", "low", "medium"],
        "Polonya": ["low", "medium", "medium", "high"],
        "Romanya": ["low", "medium", "medium"],
        "Rusya": ["low", "medium", "high"],
        "Suudi Arabistan": ["low", "medium", "high", "veryHigh"],
        "Türkiye": ["low", "low", "medium", "medium", "high"],
        "Ukrayna": ["low", "medium", "medium"],
        "Uganda": ["none", "low", "low", "medium"],
        "Yunanistan": ["low", "medium", "medium"],
        "Zimbabve": ["low", "medium", "medium", "high"]
    ]
}

extension Bool {
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}
