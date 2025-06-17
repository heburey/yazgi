import SwiftUI

struct CharacterCreationView: View {
    @State private var name = ""
    @State private var gender = ""
    @State private var country = ""
    @State private var showGame = false
    @State private var character: Character?

    let genderOptions = ["Kadın", "Erkek", "Non-binary", "Belirtmek istemiyorum", "Diğer"]
    let countryOptions = FamilyGenerator.incomeWeightsByCountry.keys.sorted()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("👤 Karakterini Oluştur")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 16) {
                    Text("İsim:")
                    HStack {
                        TextField("Adını yaz...", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            name = randomName()
                        }) {
                            Image(systemName: "dice")
                                .font(.title2)
                        }
                        .padding(.leading, 6)
                        .help("Rastgele bir isim oluştur")
                    }

                    Text("Cinsiyet:")
                    Picker("Cinsiyet", selection: $gender) {
                        ForEach(genderOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Text("Ülke:")
                    Picker("Ülke", selection: $country) {
                        ForEach(countryOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                Spacer()

                Button("🌱 Hayatı Başlat") {
                    let family = FamilyGenerator.generateFamily(for: country)

                    character = Character(
                        name: name,
                        age: 0,
                        intelligence: Int.random(in: 3...7),
                        beauty: Int.random(in: 3...7),
                        luck: Int.random(in: 3...7),
                        aura: Int.random(in: 3...7),
                        gender: gender,
                        country: country,
                        family: family
                    )

                    showGame = true
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background((name.isEmpty || gender.isEmpty || country.isEmpty) ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(name.isEmpty || gender.isEmpty || country.isEmpty)
                .padding(.horizontal)

                .navigationDestination(isPresented: $showGame) {
                    if let character = character {
                        ContentView(character: character)
                    }
                }
            }
            .padding()
        }
    }

    func randomName() -> String {
        let neutralNames = ["Deniz", "Ege", "Baran", "Aras", "Lara", "Rüya", "Ada", "Mira", "Kıvanç", "Arda"]
        return neutralNames.randomElement() ?? "İsimsiz"
    }
}
