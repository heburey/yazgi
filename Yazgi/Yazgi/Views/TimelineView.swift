import SwiftUI

struct TimelineView: View {
    let event: LifeEvent
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Başlık ve Tarih
                    VStack(spacing: 8) {
                        Text(event.description)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(event.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Konum
                    if let location = event.location {
                        LocationSection(location: location)
                    }
                    
                    // Katılımcılar
                    if !event.involvedPeople.isEmpty {
                        ParticipantsSection(participants: event.involvedPeople)
                    }
                    
                    // Etkiler
                    if let effects = event.effects {
                        EffectsSection(effects: effects)
                    }
                    
                    // Seçimler ve Sonuçları
                    if let choices = event.choices {
                        ChoicesSection(choices: choices.map { choice in
                            EventChoice(description: choice, outcome: nil)
                        })
                    }
                    
                    // Başarımlar
                    if let achievements = event.unlockedAchievements {
                        AchievementsSection(achievements: achievements)
                    }
                    
                    // Anılar ve Fotoğraflar
                    if let memories = event.memories {
                        MemoriesSection(memories: memories)
                    }
                    
                    // İlişki Değişimleri
                    if let relationships = event.relationshipChanges {
                        RelationshipChangesSection(changes: relationships)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Olay Detayları")
                        .font(.headline)
                }
            }
        }
    }
}

struct LocationSection: View {
    let location: String
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Konum", systemImage: "mappin.circle.fill")
                .font(.headline)
            
            Text(location)
                .font(.body)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ParticipantsSection: View {
    let participants: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Katılımcılar", systemImage: "person.2.fill")
                .font(.headline)
            
            ForEach(participants, id: \.self) { participant in
                Text(participant)
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EffectsSection: View {
    let effects: CharacterEffect
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Etkiler", systemImage: "waveform.path.ecg")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                if let change = effects.intelligenceChange {
                    EffectCell(title: "Zeka", value: change, color: .blue)
                }
                if let change = effects.beautyChange {
                    EffectCell(title: "Güzellik", value: change, color: .pink)
                }
                if let change = effects.luckChange {
                    EffectCell(title: "Şans", value: change, color: .green)
                }
                if let change = effects.auraChange {
                    EffectCell(title: "Aura", value: change, color: .purple)
                }
                if let change = effects.happinessChange {
                    EffectCell(title: "Mutluluk", value: change, color: .yellow)
                }
                if let change = effects.stressChange {
                    EffectCell(title: "Stres", value: change, color: .orange)
                }
                if let change = effects.karmaChange {
                    EffectCell(title: "Karma", value: change, color: .gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EffectCell: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value >= 0 ? "+\(value)" : "\(value)")
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ChoicesSection: View {
    let choices: [EventChoice]
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Seçimler", systemImage: "arrow.triangle.branch")
                .font(.headline)
            
            ForEach(choices) { choice in
                VStack(alignment: .leading, spacing: 4) {
                    Text(choice.description)
                        .font(.body)
                    
                    if let outcome = choice.outcome {
                        Text(outcome)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct AchievementsSection: View {
    let achievements: [GameAchievement]
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Başarımlar", systemImage: "star.fill")
                .font(.headline)
            
            ForEach(achievements) { achievement in
                HStack {
                    Image(systemName: achievement.icon)
                        .foregroundColor(.yellow)
                    
                    VStack(alignment: .leading) {
                        Text(achievement.title)
                            .font(.body)
                        Text(achievement.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct MemoriesSection: View {
    let memories: [Memory]
    
    var body: some View {
        VStack(spacing: 8) {
            Label("Anılar", systemImage: "photo.fill")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(memories) { memory in
                        VStack {
                            if let photo = memory.photo {
                                Image(photo)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(8)
                            }
                            
                            Text(memory.description)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .frame(width: 120)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct RelationshipChangesSection: View {
    let changes: [RelationshipChange]
    
    var body: some View {
        VStack(spacing: 8) {
            Label("İlişki Değişimleri", systemImage: "heart.fill")
                .font(.headline)
            
            ForEach(changes) { change in
                HStack {
                    Text(change.personName)
                        .font(.body)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: change.value >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(abs(change.value))")
                    }
                    .foregroundColor(change.value >= 0 ? .green : .red)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    TimelineView(event: LifeEvent(
        title: "Üniversite Mezuniyeti",
        description: "Üniversiteden mezun oldun!",
        date: Date(),
        type: LifeEventType.education,
        impact: 8,
        effects: [
            CharacterEffect(
                type: CharacterEffectType.intelligence,
                value: 5,
                source: "Mezuniyet",
                description: "Zeka artışı"
            ),
            CharacterEffect(
                type: CharacterEffectType.happiness,
                value: 10,
                source: "Mezuniyet",
                description: "Mutluluk artışı"
            )
        ],
        memories: []
    ))
} 