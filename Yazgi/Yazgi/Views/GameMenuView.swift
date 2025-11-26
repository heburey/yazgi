import SwiftUI

struct GameMenuView: View {
    @ObservedObject var viewModel: GameViewModel

    private var menuActions: [MenuAction] {
        [
            MenuAction(
                title: "Sağlık",
                icon: "cross.case.fill",
                color: .red,
                note: "Doktor, spor, diyet"
            ) { viewModel.logCategoryVisit("Sağlık", note: "Sağlık menüsüne göz attın") },
            MenuAction(
                title: "Eğitim",
                icon: "graduationcap.fill",
                color: .blue,
                note: "Okul, kurs, burs"
            ) { viewModel.logCategoryVisit("Eğitim", note: "Eğitim planlarını kontrol ettin") },
            MenuAction(
                title: "İş & Para",
                icon: "briefcase.fill",
                color: .green,
                note: "İş ara, maaş, yatırım"
            ) { viewModel.logCategoryVisit("İş & Para", note: "İş ve finans menüsüne baktın") },
            MenuAction(
                title: "İlişkiler",
                icon: "heart.fill",
                color: .pink,
                note: "Partner, aile, çocuk"
            ) { viewModel.logCategoryVisit("İlişkiler", note: "İlişkilerini gözden geçirdin") },
            MenuAction(
                title: "Alışveriş",
                icon: "cart.fill",
                color: .orange,
                note: "Mağazalar, lüks, yaşam"
            ) { viewModel.logCategoryVisit("Alışveriş", note: "Alışverişe baktın") },
            MenuAction(
                title: "Sosyal & Suç",
                icon: "hand.raised.fill",
                color: .purple,
                note: "Arkadaşlık ve riskli işler"
            ) { viewModel.logCategoryVisit("Sosyal", note: "Sosyal ve riskli seçeneklere baktın") }
        ]
    }

    private var checklistActions: [ChecklistAction] {
        [
            ChecklistAction(title: "Doktora git", subtitle: "Sağlık", icon: "cross.case", color: .red) {
                viewModel.logCategoryVisit("Sağlık", note: "Doktora göz attın")
            },
            ChecklistAction(title: "Spor salonu", subtitle: "Sağlık", icon: "figure.run", color: .red) {
                viewModel.logCategoryVisit("Sağlık", note: "Spor salonuna baktın")
            },
            ChecklistAction(title: "Okul bilgileri", subtitle: "Eğitim", icon: "book.fill", color: .blue) {
                viewModel.logCategoryVisit("Eğitim", note: "Okul bilgilerini kontrol ettin")
            },
            ChecklistAction(title: "Üniversite başvurusu", subtitle: "Eğitim", icon: "graduationcap.fill", color: .blue) {
                viewModel.logCategoryVisit("Eğitim", note: "Üniversite seçeneklerine baktın")
            },
            ChecklistAction(title: "İş ara", subtitle: "İş & Para", icon: "magnifyingglass.circle.fill", color: .green) {
                viewModel.logCategoryVisit("İş & Para", note: "İş ilanlarına baktın")
            },
            ChecklistAction(title: "Maaş / vergiler", subtitle: "İş & Para", icon: "banknote", color: .green) {
                viewModel.logCategoryVisit("İş & Para", note: "Maaş durumunu kontrol ettin")
            },
            ChecklistAction(title: "Yatırım yap", subtitle: "İş & Para", icon: "chart.line.uptrend.xyaxis", color: .green) {
                viewModel.logCategoryVisit("İş & Para", note: "Yatırım seçeneklerine baktın")
            },
            ChecklistAction(title: "Partner bul", subtitle: "İlişkiler", icon: "heart.text.square", color: .pink) {
                viewModel.logCategoryVisit("İlişkiler", note: "Partner aradın")
            },
            ChecklistAction(title: "Aile ilişkileri", subtitle: "İlişkiler", icon: "person.2.fill", color: .pink) {
                viewModel.logCategoryVisit("İlişkiler", note: "Aile ilişkilerini kontrol ettin")
            },
            ChecklistAction(title: "Ev / araba satın al", subtitle: "Varlıklar", icon: "house.fill", color: .purple) {
                viewModel.logCategoryVisit("Varlıklar", note: "Varlık baktın")
            },
            ChecklistAction(title: "Alışveriş yap", subtitle: "Alışveriş", icon: "bag.fill", color: .orange) {
                viewModel.logCategoryVisit("Alışveriş", note: "Mağazaya baktın")
            },
            ChecklistAction(title: "Arkadaş bul", subtitle: "Sosyal", icon: "person.3.fill", color: .teal) {
                viewModel.logCategoryVisit("Sosyal", note: "Sosyal çevreye baktın")
            },
            ChecklistAction(title: "Kumar / suç", subtitle: "Risk", icon: "exclamationmark.triangle.fill", color: .gray) {
                viewModel.logCategoryVisit("Suç", note: "Riskli işlere baktın")
            }
        ]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    overviewCard
                    attributesCard
                    quickActionsGrid
                    checklistSection
                    familySection
                    logSection
                }
                .padding(16)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Panorama")
        }
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red.opacity(0.85), .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 62, height: 62)
                    Text(String(viewModel.character.name.prefix(1)).uppercased())
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.character.name), \(viewModel.character.age) yaş")
                        .font(.headline)
                    Text("\(viewModel.character.country) • \(viewModel.character.gender)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(viewModel.character.jobTitle ?? "İş: Henüz yok")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    statPill(icon: "banknote.fill", title: "Para", value: "₺\(viewModel.character.money)")
                    statPill(icon: "clock.fill", title: "Yaş", value: "\(viewModel.character.age)")
                }
            }

            Divider()

            HStack(spacing: 8) {
                chip(icon: "heart.fill", text: viewModel.character.relationshipStatus.rawValue)
                chip(icon: "graduationcap.fill", text: viewModel.character.educationLevel.rawValue)
                chip(icon: "figure.walk", text: viewModel.character.careerPath.rawValue)
                chip(icon: "person.badge.shield.checkmark.fill", text: viewModel.character.sexualOrientation.rawValue)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var attributesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Özellikler")
                    .font(.headline)
                Spacer()
                Text("0 - 100")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            AttributeBar(label: "❤️ Sağlık", value: viewModel.character.health)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "😊 Mutluluk", value: viewModel.character.happiness)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "🧠 Zeka", value: viewModel.character.smarts)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "✨ Görünüm", value: viewModel.character.looks)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "🎓 Eğitim Prestiji", value: viewModel.character.educationPrestige)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "🤝 Network", value: viewModel.character.network)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "🏛 Saygınlık", value: viewModel.character.reputation)
                .frame(maxWidth: .infinity)
            AttributeBar(label: "💸 Maddi Güç", value: viewModel.character.incomePower)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Kısayollar")
                    .font(.headline)
                Spacer()
                Text("BitLife menüleri")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(menuActions) { action in
                    Button {
                        action.perform()
                    } label: {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: action.icon)
                                .font(.title3)
                                .frame(width: 46, height: 46)
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
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Yapılacaklar")
                    .font(.headline)
                Spacer()
                Text("Bir tıkla ilerle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(checklistActions) { action in
                Button {
                    action.perform()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: action.icon)
                            .frame(width: 32, height: 32)
                            .foregroundColor(action.color)
                            .background(action.color.opacity(0.15))
                            .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(action.title)
                                .font(.subheadline)
                            Text(action.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                }
                .buttonStyle(.plain)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var familySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Aile & Yakınlar")
                    .font(.headline)
                Spacer()
                Text(viewModel.character.family.maritalStatus.rawValue.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let spouse = viewModel.character.spouse {
                familyRow(
                    title: "Eş",
                    name: spouse.name,
                    detail: spouse.occupation ?? "Meslek bilinmiyor",
                    badge: "Evli",
                    color: .pink
                )
            } else {
                Text("Eş yok, ilişkide değilsin.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.character.children.isEmpty {
                Text("Çocuk bulunmuyor.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.character.children) { child in
                    familyRow(
                        title: "Çocuk (\(child.age))",
                        name: child.name,
                        detail: child.gender,
                        badge: "Bağ: \(child.relationshipQuality)",
                        color: .blue
                    )
                }
            }

            Divider()

            ForEach(viewModel.character.family.parents, id: \.id) { parent in
                VStack(alignment: .leading, spacing: 6) {
                    Text(parent.role == .mother ? "Anne" : "Baba")
                        .font(.subheadline)
                        .bold()
                    if let name = parent.name {
                        Text(name)
                            .font(.subheadline)
                    } else {
                        Text("Ad bilinmiyor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if let job = parent.occupation {
                        Text(job)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("Gelir: \(parent.incomeLevel.rawValue.capitalized)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(parent.isAlive ? "Hayatta" : "Hayatta değil")
                        .font(.caption)
                        .foregroundStyle(parent.isAlive ? .green : .red)
                    if !parent.isAlive, let cause = parent.deathCause {
                        Text("Ölüm nedeni: \(cause.rawValue.capitalized)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(10)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var logSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Olay Günlüğü")
                    .font(.headline)
                Spacer()
                Text("Son \(min(viewModel.lifeLog.count, 10)) kayıt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.lifeLog.isEmpty {
                Text("Henüz kayıt yok.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.lifeLog.prefix(10)) { event in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("\(event.age) yaş")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text(tag(for: event.kind))
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
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
                    .padding(10)
                    .background(Color(UIColor.secondarySystemFill))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func statPill(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.footnote)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
        .foregroundColor(.primary)
    }

    private func chip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(12)
    }

    private func familyRow(title: String, name: String, detail: String, badge: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(Text(String(name.prefix(1))).font(.headline))

            VStack(alignment: .leading, spacing: 4) {
                Text("\(title): \(name)")
                    .font(.subheadline)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(badge)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.15))
                .cornerRadius(8)
        }
        .padding(10)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(12)
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

private struct MenuAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let note: String
    let perform: () -> Void
}

private struct ChecklistAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let perform: () -> Void
}
