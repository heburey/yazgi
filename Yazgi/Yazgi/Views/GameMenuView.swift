import SwiftUI

struct GameMenuView: View {
    let character: Character
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                // Üst bilgi kartı
                CharacterInfoCard(character: character)
                    .padding()
                
                // Tab seçici
                Picker("Kategori", selection: $selectedTab) {
                    Text("İlişkiler").tag(0)
                    Text("Aile").tag(1)
                    Text("Varlıklar").tag(2)
                    Text("Kariyer").tag(3)
                    Text("Sağlık").tag(4)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Tab içeriği
                TabView(selection: $selectedTab) {
                    RelationshipsView(character: character)
                        .tag(0)
                    
                    FamilyView(character: character)
                        .tag(1)
                    
                    AssetsView(character: character)
                        .tag(2)
                    
                    CareerView(character: character)
                        .tag(3)
                    
                    HealthView(character: character)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Yaşam Detayları")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CharacterInfoCard: View {
    let character: Character
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.title2)
                        .bold()
                    Text("\(character.age) yaşında")
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("💰 \(formatCurrency(character.netWorth))")
                    .font(.headline)
            }
            
            HStack {
                StatusIndicator(icon: "brain", value: character.intelligence, color: .blue)
                StatusIndicator(icon: "sparkles", value: character.aura, color: .purple)
                StatusIndicator(icon: "heart", value: character.beauty, color: .pink)
                StatusIndicator(icon: "leaf", value: character.luck, color: .green)
            }
            
            HStack {
                StatusIndicator(icon: "face.smiling", value: character.happiness, color: .yellow)
                StatusIndicator(icon: "bolt", value: character.stress, color: .orange)
                StatusIndicator(icon: "yin.yang", value: character.karma + 100, color: .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "₺0"
    }
}

struct StatusIndicator: View {
    let icon: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            ProgressView(value: Float(value), total: 100)
                .tint(color)
                .frame(width: 40)
            Text("\(value)%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct RelationshipsView: View {
    let character: Character
    
    var body: some View {
        List {
            ForEach(character.relationships) { relationship in
                RelationshipRow(relationship: relationship)
            }
        }
    }
}

struct RelationshipRow: View {
    let relationship: Relationship
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(relationship.partner.name)
                    .font(.headline)
                Spacer()
                Text(relationship.type.rawValue)
                    .font(.caption)
                    .padding(4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            HStack {
                Text("Uyum: \(relationship.partner.compatibility)%")
                    .font(.subheadline)
                Spacer()
                ForEach(relationship.partner.traits.prefix(3), id: \.self) { trait in
                    Text(trait.rawValue)
                        .font(.caption)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct FamilyView: View {
    let character: Character
    
    var body: some View {
        List {
            Section("Ebeveynler") {
                ForEach(character.family.parents) { parent in
                    if parent.isKnown {
                        ParentRow(parent: parent)
                    }
                }
            }
            
            if character.family.isAdopted {
                Text("Evlat Edinilmiş")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if character.family.maritalStatus == .divorced {
                Section("Velayet") {
                    Text("Velayet: \(character.family.custody?.rawValue ?? "Bilinmiyor")")
                }
            }
        }
    }
}

struct ParentRow: View {
    let parent: Parent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(parent.name ?? "Bilinmiyor")
                    .font(.headline)
                Spacer()
                if !parent.isAlive {
                    Text("†")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            
            if let occupation = parent.occupation {
                Text(occupation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !parent.isAlive, let cause = parent.deathCause {
                Text("Ölüm Nedeni: \(cause.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AssetsView: View {
    let character: Character
    @State private var selectedAssetType: AssetType?
    
    var body: some View {
        List {
            ForEach(AssetType.allCases, id: \.self) { type in
                Section(type.rawValue) {
                    let typeAssets = character.assets.filter { $0.type == type }
                    if typeAssets.isEmpty {
                        Text("Henüz yok")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(typeAssets) { asset in
                            AssetRow(asset: asset)
                        }
                    }
                }
            }
        }
    }
}

struct AssetRow: View {
    let asset: Asset
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(asset.name)
                    .font(.headline)
                Spacer()
                Text(formatCurrency(asset.value))
                    .font(.subheadline)
            }
            
            if let expense = asset.monthlyExpense {
                Text("Aylık Gider: \(formatCurrency(expense))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let pet = asset.petDetails {
                HStack {
                    StatusIndicator(icon: "heart.fill", value: pet.health, color: .red)
                    StatusIndicator(icon: "face.smiling", value: pet.happiness, color: .yellow)
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "₺0"
    }
}

struct CareerView: View {
    let character: Character
    
    var body: some View {
        List {
            if let career = character.career {
                Section("Kariyer") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(career.title)
                            .font(.headline)
                        Text(career.company)
                            .font(.subheadline)
                        
                        HStack {
                            Text("Seviye: \(career.level.rawValue)")
                            Spacer()
                            Text("Maaş: \(formatCurrency(career.salary))")
                        }
                        .font(.caption)
                        
                        HStack {
                            StatusIndicator(icon: "heart.fill", value: career.satisfaction, color: .red)
                            StatusIndicator(icon: "bolt.fill", value: career.stress, color: .orange)
                        }
                    }
                }
                
                Section("Yetenekler") {
                    ForEach(career.skills, id: \.self) { skill in
                        Text(skill)
                    }
                }
                
                Section("Başarılar") {
                    ForEach(career.achievements, id: \.self) { achievement in
                        Text(achievement)
                    }
                }
            }
            
            if let education = character.education {
                Section("Eğitim") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(education.level.rawValue)
                            .font(.headline)
                        
                        if let field = education.field {
                            Text(field)
                                .font(.subheadline)
                        }
                        
                        if let institution = education.institution {
                            Text(institution)
                                .font(.caption)
                        }
                        
                        if let gpa = education.gpa {
                            Text("GPA: \(String(format: "%.2f", gpa))")
                                .font(.caption)
                        }
                        
                        if let debt = education.studentDebt {
                            Text("Öğrenim Kredisi: \(formatCurrency(debt))")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "₺0"
    }
}

struct HealthView: View {
    let character: Character
    
    var body: some View {
        List {
            Section("Genel Sağlık") {
                VStack(spacing: 12) {
                    HStack {
                        StatusIndicator(icon: "heart.fill", value: character.health.physicalHealth, color: .red)
                        Text("Fiziksel Sağlık")
                    }
                    
                    HStack {
                        StatusIndicator(icon: "brain.head.profile", value: character.health.mentalHealth, color: .purple)
                        Text("Ruh Sağlığı")
                    }
                }
                .padding(.vertical, 8)
            }
            
            if let conditions = character.health.conditions, !conditions.isEmpty {
                Section("Sağlık Durumları") {
                    ForEach(conditions, id: \.name) { condition in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(condition.name)
                                .font(.headline)
                            Text("Şiddet: \(condition.severity)%")
                                .font(.caption)
                            if condition.chronic {
                                Text("Kronik")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            if let treatment = condition.treatment {
                                Text("Tedavi: \(treatment)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            
            if let medications = character.health.medications, !medications.isEmpty {
                Section("İlaçlar") {
                    ForEach(medications, id: \.self) { medication in
                        Text(medication)
                    }
                }
            }
            
            if let allergies = character.health.allergies, !allergies.isEmpty {
                Section("Alerjiler") {
                    ForEach(allergies, id: \.self) { allergy in
                        Text(allergy)
                    }
                }
            }
            
            Section("Fiziksel Özellikler") {
                if let height = character.health.height {
                    Text("Boy: \(String(format: "%.1f", height)) cm")
                }
                if let weight = character.health.weight {
                    Text("Kilo: \(String(format: "%.1f", weight)) kg")
                }
                if let bloodType = character.health.bloodType {
                    Text("Kan Grubu: \(bloodType)")
                }
            }
            
            if let lastCheckup = character.health.lastCheckup {
                Section("Son Kontrol") {
                    Text(lastCheckup, style: .date)
                }
            }
        }
    }
}
