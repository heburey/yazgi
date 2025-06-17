import Foundation

struct Asset: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var type: AssetType
    var value: Double
    var purchaseDate: Date
    var condition: AssetCondition
    var location: String?
    var description: String?
    var monthlyExpense: Double?
    var monthlyIncome: Double?
    var appreciationRate: Double?
    var insurance: Insurance?
    var loanBalance: Double?
    var isShared: Bool
    var coOwners: [String]?
    
    // Hesaplanan özellikler
    var currentValue: Double {
        if let rate = appreciationRate {
            let years = Calendar.current.dateComponents([.year], from: purchaseDate, to: Date()).year ?? 0
            return value * pow(1 + rate, Double(years))
        }
        return value
    }
    
    var monthlyNetIncome: Double {
        (monthlyIncome ?? 0) - (monthlyExpense ?? 0)
    }
    
    var equity: Double {
        currentValue - (loanBalance ?? 0)
    }
}

enum AssetType: String, Codable {
    case realEstate = "Gayrimenkul"
    case vehicle = "Araç"
    case investment = "Yatırım"
    case business = "İşletme"
    case jewelry = "Mücevher"
    case artwork = "Sanat Eseri"
    case electronics = "Elektronik"
    case furniture = "Mobilya"
    case cryptocurrency = "Kripto Para"
    case collectible = "Koleksiyon"
    case other = "Diğer"
}

enum AssetCondition: String, Codable {
    case excellent = "Mükemmel"
    case good = "İyi"
    case fair = "Orta"
    case poor = "Kötü"
    case damaged = "Hasarlı"
}

struct Insurance: Codable {
    var provider: String
    var policyNumber: String
    var coverage: Double
    var monthlyPremium: Double
    var startDate: Date
    var endDate: Date
    var type: InsuranceType
    var deductible: Double?
    var beneficiaries: [String]?
}

enum InsuranceType: String, Codable {
    case life = "Hayat"
    case health = "Sağlık"
    case property = "Mülk"
    case vehicle = "Araç"
    case liability = "Sorumluluk"
    case business = "İşletme"
}

// MARK: - Preview Helper
extension Asset {
    static var preview: Asset {
        Asset(
            name: "Şehir Merkezi Daire",
            type: .realEstate,
            value: 1_500_000,
            purchaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!,
            condition: .excellent,
            location: "İstanbul, Kadıköy",
            description: "2+1, 120m², 5. kat",
            monthlyExpense: 2000,
            monthlyIncome: 8000,
            appreciationRate: 0.1,
            insurance: Insurance(
                provider: "Güven Sigorta",
                policyNumber: "POL123456",
                coverage: 1_000_000,
                monthlyPremium: 500,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                type: .property,
                deductible: 5000,
                beneficiaries: nil
            ),
            loanBalance: 500_000,
            isShared: false,
            coOwners: nil
        )
    }
} 