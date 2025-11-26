import SwiftUI

struct GameMenuView: View {
    let character: Character

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Aile")) {
                    ForEach(character.family.parents, id: \.id) { parent in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(parent.role == .mother ? "Anne" : "Baba")
                                .font(.headline)

                            if let name = parent.name {
                                Text("Adı: \(name)")
                            }
                            if let job = parent.occupation {
                                Text("Meslek: \(job)")
                            }
                            Text("Gelir: \(parent.incomeLevel.rawValue.capitalized)")
                            Text("Hayatta mı: \(parent.isAlive ? "Evet" : "Hayır")")
                            if !parent.isAlive, let cause = parent.deathCause {
                                Text("Ölüm nedeni: \(cause.rawValue.capitalized)")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Ek kategoriler yakında:
                Section(header: Text("İlişkiler")) {
                    Text("Henüz kimse yok 😅")
                }

                Section(header: Text("Evcil Hayvanlar")) {
                    Text("Henüz sahip değiliz 🐾")
                }

                Section(header: Text("Mal Varlıkları")) {
                    Text("Boş... Şimdilik 🏡")
                }
            }
            .navigationTitle("Hayatım")
        }
    }
}
