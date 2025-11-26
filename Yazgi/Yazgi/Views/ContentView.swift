import SwiftUI

struct ContentView: View {
    let character: Character
    @StateObject private var viewModel: GameViewModel
    @State private var showMenu = false

    init(character: Character) {
        _viewModel = StateObject(wrappedValue: GameViewModel(character: character))
        self.character = character
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        heroCard
                        primaryStats
                        secondaryStats
                        quickActions
                        mainEventCard
                        activitiesSection
                        timelineSection
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }

                ageButton
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .background(.ultraThickMaterial)
            }
            .navigationTitle("Yazgı")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showMenu = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                GameMenuView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Sections

    private var heroCard: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.92, green: 0.24, blue: 0.26)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(viewModel.character.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    if viewModel.character.isDead {
                        Text("💀")
                    }
                }

                Text("\(viewModel.character.age) yaş • \(viewModel.character.country) • \(viewModel.character.gender)")
                    .foregroundColor(.white.opacity(0.8))

                HStack(spacing: 8) {
                    Chip(text: viewModel.character.sexualOrientation.rawValue)
                    Chip(text: viewModel.character.careerPath.rawValue)
                    Chip(text: viewModel.character.relationshipStatus.rawValue)
                }

                HStack(spacing: 16) {
                    MiniStat(title: "Para", value: "₺\(viewModel.character.money)", systemIcon: "banknote.fill")
                    MiniStat(title: "Maaş", value: viewModel.character.salary > 0 ? "₺\(viewModel.character.salary)/y" : "—", systemIcon: "briefcase.fill")
                    MiniStat(title: "Eğitim", value: viewModel.character.educationLevel.rawValue, systemIcon: "graduationcap.fill")
                }
            }
            .padding(20)
        }
    }

    private var primaryStats: some View {
        VStack(spacing: 8) {
            StatTile(icon: "heart.fill", title: "Sağlık", value: viewModel.character.health, color: .red)
            StatTile(icon: "face.smiling.fill", title: "Mutluluk", value: viewModel.character.happiness, color: .orange)
            StatTile(icon: "brain.head.profile", title: "Zeka", value: viewModel.character.smarts, color: .yellow)
            StatTile(icon: "sparkles", title: "Görünüm", value: viewModel.character.looks, color: .pink)
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }

    private var secondaryStats: some View {
        VStack(spacing: 8) {
            StatTile(icon: "book.fill", title: "Eğitim Prestiji", value: viewModel.character.educationPrestige, color: .blue)
            StatTile(icon: "person.3.fill", title: "Network", value: viewModel.character.network, color: .teal)
            StatTile(icon: "rosette", title: "Saygınlık", value: viewModel.character.reputation, color: .purple)
            StatTile(icon: "banknote.fill", title: "Maddi Güç", value: viewModel.character.incomePower, color: .green)
        }
        .padding(14)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Hızlı Aksiyonlar")
                    .font(.headline)
                Spacer()
                Text("BitLife menüleri")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(CategoryAction.presets) { action in
                    Button {
                        viewModel.logCategoryVisit(action.title, note: action.note)
                        showMenu = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: action.icon)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(action.color.opacity(0.15))
                                .foregroundColor(action.color)
                                .cornerRadius(12)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.title)
                                    .font(.subheadline)
                                    .bold()
                                Text(action.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                }
            }
        }
    }

    private var mainEventCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ana Olay")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.character.age) yaş")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text(viewModel.currentNode.title ?? "Olay")
                .font(.title3)
                .bold()
            Text(viewModel.currentNode.description)
                .font(.body)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(viewModel.currentNode.options, id: \.text) { option in
                    Button {
                        viewModel.choose(option: option)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(option.text)
                                    .fontWeight(.semibold)
                                if let effect = option.effect {
                                    Text(effectPreview(effect))
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.85))
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .background(viewModel.mainEventResolved || viewModel.character.isDead ? Color.gray.opacity(0.4) : Color(red: 0.9, green: 0.15, blue: 0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(viewModel.mainEventResolved || viewModel.character.isDead)
                }
            }

            if viewModel.mainEventResolved {
                Text("Bu yıl ana olayı seçtin. İstersen aktiviteleri dene veya yaş al.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Aktiviteler")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.availableActivities.count) seçenek")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if viewModel.availableActivities.isEmpty {
                Text("Bu yaşta ek aktivite yok, ana olaya odaklan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.availableActivities) { activity in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(activity.category.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(UIColor.secondarySystemFill))
                                .cornerRadius(8)
                            Spacer()
                        }
                        Text(activity.title)
                            .font(.subheadline)
                            .bold()
                        Text(activity.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button {
                            viewModel.use(activity: activity)
                        } label: {
                            HStack {
                                Text("Uygula")
                                    .fontWeight(.semibold)
                                Spacer()
                                if let effect = activity.effect {
                                    Text(effectPreview(effect))
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color.green.opacity(0.18))
                                        .cornerRadius(8)
                                }
                                Image(systemName: "play.fill")
                            }
                            .padding(10)
                        }
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Yaşam Günlüğü")
                    .font(.headline)
                Spacer()
                Text("Son \(min(viewModel.lifeLog.count, 8))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if viewModel.lifeLog.isEmpty {
                Text("Henüz kaydedilmiş bir olay yok. İlk seçimini yap!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.lifeLog.prefix(8)) { event in
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(event.age) yaş")
                                    .font(.subheadline)
                                    .bold()
                                Text(tag(for: event.kind))
                                    .font(.caption2)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.12))
                                    .cornerRadius(8)
                            }
                            Text(event.title)
                                .font(.subheadline)
                            Text("Seçim: \(event.choice)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if let impact = event.impact {
                                Text(impact)
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.green.opacity(0.15))
                                    .cornerRadius(8)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(14)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private var ageButton: some View {
        Button {
            viewModel.advanceYear()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.character.isDead ? "Öldün" : "Yaş Al")
                        .font(.headline)
                    Text(viewModel.character.isDead ? "Hayat sona erdi" : "Yeni yıl, yeni olaylar")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: viewModel.character.isDead ? "xmark.circle.fill" : "arrow.forward.circle.fill")
                    .font(.title2)
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(viewModel.character.isDead ? Color.gray : Color(red: 0.9, green: 0.15, blue: 0.15))
            .cornerRadius(16)
        }
        .disabled(viewModel.character.isDead)
    }

    // MARK: - Helpers

    private func effectPreview(_ effect: CharacterEffect) -> String {
        var parts: [String] = []

        if let delta = effect.intelligenceChange { parts.append("Zeka \(signed(delta))") }
        if let delta = effect.auraChange { parts.append("Aura \(signed(delta))") }
        if let delta = effect.beautyChange { parts.append("Güz \(signed(delta))") }
        if let delta = effect.luckChange { parts.append("Şans \(signed(delta))") }
        if let delta = effect.educationPrestigeChange { parts.append("Prestij \(signed(delta))") }
        if let delta = effect.networkChange { parts.append("Network \(signed(delta))") }
        if let delta = effect.reputationChange { parts.append("Saygın \(signed(delta))") }
        if let delta = effect.incomePowerChange { parts.append("Para \(signed(delta))") }
        if let career = effect.setCareerPath { parts.append("Kariyer → \(career.rawValue)") }
        if let delta = effect.healthChange { parts.append("Sağlık \(signed(delta))") }
        if let delta = effect.happinessChange { parts.append("Mutluluk \(signed(delta))") }
        if let delta = effect.smartsChange { parts.append("Zeka \(signed(delta))") }
        if let delta = effect.looksChange { parts.append("Görünüm \(signed(delta))") }
        if let delta = effect.moneyChange { parts.append("₺\(signed(delta))") }
        if let edu = effect.setEducation { parts.append("Eğitim \(edu.rawValue)") }
        if let rel = effect.setRelationship { parts.append("İlişki \(rel.rawValue)") }
        if let job = effect.setJobTitle { parts.append("İş \(job)") }

        return parts.prefix(3).joined(separator: " • ")
    }

    private func signed(_ value: Int) -> String {
        value > 0 ? "+\(value)" : "\(value)"
    }

    private func tag(for kind: LifeEventKind) -> String {
        switch kind {
        case .main: return "Ana"
        case .activity: return "Aktivite"
        case .age: return "Yaş"
        case .random: return "Olay"
        case .career: return "Kariyer"
        case .relationship: return "İlişki"
        case .milestone: return "Dönüm"
        }
    }
}

// MARK: - Reusable UI

private struct Chip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .foregroundColor(.white)
    }
}

private struct MiniStat: View {
    let title: String
    let value: String
    let systemIcon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemIcon)
                .font(.caption)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.18))
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}

private struct StatTile: View {
    let icon: String
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                    Spacer()
                    Text("%\(value)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(color)
                }
                ProgressView(value: Float(value), total: 100)
                    .tint(color)
            }
        }
        .padding(.vertical, 2)
    }
}

private struct CategoryAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let note: String

    static let presets: [CategoryAction] = [
        .init(title: "Sağlık", icon: "cross.case.fill", color: .red, note: "Doktor, spor, diyet"),
        .init(title: "Eğitim", icon: "graduationcap.fill", color: .blue, note: "Okul, kurs, burs"),
        .init(title: "İş & Para", icon: "briefcase.fill", color: .green, note: "İş ara, maaş, yatırım"),
        .init(title: "İlişkiler", icon: "heart.fill", color: .pink, note: "Partner, aile, çocuk"),
        .init(title: "Alışveriş", icon: "cart.fill", color: .orange, note: "Market, elektronik"),
        .init(title: "Varlıklar", icon: "house.fill", color: .purple, note: "Ev, araba, mülk"),
        .init(title: "Sosyal", icon: "person.3.fill", color: .teal, note: "Arkadaş, kulüp"),
        .init(title: "Suç", icon: "hand.raised.fill", color: .gray, note: "Riskli işlere gir")
    ]
}
