import SwiftUI

struct CharacterCreationView: View {
    private static let defaultGenders = ["Kadın", "Erkek", "Non-binary", "Belirtmek istemiyorum", "Diğer"]
    private static let defaultCountries = FamilyGenerator.incomeWeightsByCountry.keys.sorted()

    @State private var name = ""
    @State private var gender = CharacterCreationView.defaultGenders.first ?? ""
    @State private var country = CharacterCreationView.defaultCountries.first ?? ""
    @State private var showGame = false
    @State private var character: Character?

    let genderOptions = CharacterCreationView.defaultGenders
    let countryOptions = CharacterCreationView.defaultCountries

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

                    let baseline = baseStat(for: family.householdIncomeLevel)
                    let eduBase = educationBase(for: family.householdIncomeLevel)
                    let networkBase = networkBaseScore(for: family.householdIncomeLevel)

                    character = Character(
                        name: name,
                        age: 0,
                        health: 90,
                        happiness: 85,
                        smarts: jittered(base: baseline, spread: 12),
                        looks: jittered(base: baseline, spread: 12),
                        intelligence: jittered(base: baseline, spread: 12),
                        beauty: jittered(base: baseline, spread: 14),
                        luck: jittered(base: 48, spread: 18),
                        aura: jittered(base: baseline, spread: 10),
                        educationPrestige: jittered(base: eduBase, spread: 12),
                        network: jittered(base: networkBase, spread: 15),
                        reputation: jittered(base: 50, spread: 20),
                        incomePower: jittered(base: incomeBase(for: family.householdIncomeLevel), spread: 15),
                        money: Int.random(in: 0...5000),
                        educationLevel: .primary,
                        jobTitle: nil,
                        relationshipStatus: .single,
                        gender: gender,
                        country: country,
                        sexualOrientation: .questioning,
                        careerPath: CareerPath.random(),
                        occupation: nil,
                        family: family,
                        spouse: nil,
                        children: [],
                        salary: 0,
                        isDead: false,
                        deathCause: nil,
                        yearOfDeath: nil,
                        criminalRecord: [],
                        achievements: []
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

    private func baseStat(for income: IncomeLevel) -> Int {
        switch income {
        case .none: return 28
        case .low: return 40
        case .medium: return 55
        case .high: return 70
        case .veryHigh: return 80
        }
    }

    private func jittered(base: Int, spread: Int) -> Int {
        let raw = base + Int.random(in: -spread...spread)
        return min(100, max(0, raw))
    }

    private func educationBase(for income: IncomeLevel) -> Int {
        switch income {
        case .none: return 25
        case .low: return 45
        case .medium: return 60
        case .high: return 75
        case .veryHigh: return 85
        }
    }

    private func networkBaseScore(for income: IncomeLevel) -> Int {
        switch income {
        case .none: return 20
        case .low: return 35
        case .medium: return 55
        case .high: return 70
        case .veryHigh: return 82
        }
    }

    private func incomeBase(for income: IncomeLevel) -> Int {
        switch income {
        case .none: return 18
        case .low: return 35
        case .medium: return 55
        case .high: return 72
        case .veryHigh: return 88
        }
    }
}
