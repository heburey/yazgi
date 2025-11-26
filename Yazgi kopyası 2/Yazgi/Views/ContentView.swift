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
            VStack(spacing: 20) {
                Text("👶 Yaş: \(viewModel.character.age)")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 6) {
                    AttributeBar(label: "🧠 Zeka", value: viewModel.character.intelligence)
                    AttributeBar(label: "✨ Aura", value: viewModel.character.aura)
                    AttributeBar(label: "💅 Güzellik", value: viewModel.character.beauty)
                    AttributeBar(label: "🍀 Şans", value: viewModel.character.luck)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)

                Divider()

                Text(viewModel.currentNode.description)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                ForEach(viewModel.currentNode.options, id: \.text) { option in
                    Button(option.text) {
                        viewModel.choose(option: option)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showMenu = true
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                GameMenuView(character: character)
            }
        }
    }
}

struct AttributeBar: View {
    var label: String
    var value: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label) %\(value)")
                .font(.subheadline)
            ProgressView(value: Float(value), total: 100)
                .tint(Color(red: 0.4, green: 0.6, blue: 0.95))
        }
    }
}
