import SwiftUI

struct ContentView: View {
    let character: Character
    @StateObject private var viewModel: GameViewModel
    @State private var showMenu = false
    @State private var showNotification = false
    @State private var currentNotification: GameNotification?
    @State private var showHistory = false
    @State private var isTransitioning = false
    @State private var selectedTransitionType: TransitionType = .fade
    
    // Efekt durumları
    @State private var showRainEffect = false
    @State private var showSnowEffect = false
    @State private var showLeafEffect = false
    @State private var showFlowerEffect = false
    @State private var currentSeason: Season = .spring
    @State private var weatherIntensity: Double = 0.5
    
    init(character: Character) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(character: character))
        self.character = character
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Arka plan
                    BackgroundView(
                        timeOfDay: viewModel.currentNode.timeOfDay ?? .morning,
                        weather: viewModel.currentNode.weather ?? .sunny,
                        season: viewModel.currentNode.season ?? .spring
                    )
                    
                    // Hava efektleri
                    if showRainEffect {
                        RainEffect(intensity: weatherIntensity)
                    }
                    if showSnowEffect {
                        SnowEffect(intensity: weatherIntensity)
                    }
                    if showLeafEffect {
                        LeafEffect(intensity: weatherIntensity, season: currentSeason)
                    }
                    if showFlowerEffect {
                        FlowerEffect(intensity: weatherIntensity, flowerType: .sakura)
                    }
                    
                    // Ana içerik
                    VStack(spacing: 20) {
                        // Karakter bilgileri
                        CharacterInfoView(character: character)
                            .padding()
                        
                        // Hikaye içeriği
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                // Özel içerik
                                if let customContent = viewModel.currentNode.customContent {
                                    ForEach(customContent, id: \.content) { content in
                                        CustomContentView(content: content)
                                    }
                                }
                                
                                // Hikaye metni
                                Text(viewModel.currentNode.description)
                                    .font(.body)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                
                                // Seçenekler
                                ForEach(viewModel.currentNode.options, id: \.text) { option in
                                    OptionButton(
                                        option: option,
                                        action: {
                                            handleOptionSelection(option)
                                        }
                                    )
                                    .disabled(isTransitioning)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Bildirimler
                    if showNotification, let notification = currentNotification {
                        NotificationView(notification: notification) {
                            withAnimation {
                                showNotification = false
                            }
                        }
                    }
                    
                    // Geçmiş görünümü
                    if showHistory {
                        HistoryView(events: viewModel.character.lifeEvents) {
                            withAnimation {
                                showHistory = false
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showHistory.toggle()
                        }
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                GameMenuView(character: character)
            }
        }
        .onChange(of: viewModel.currentNode) { newNode in
            updateEffects(for: newNode)
        }
    }
    
    private func handleOptionSelection(_ option: StoryOption) {
        // Geçiş animasyonunu başlat
        isTransitioning = true
        
        // Geçiş tipini belirle
        if let transitionType = viewModel.currentNode.transitionType {
            selectedTransitionType = TransitionType(rawValue: transitionType) ?? .fade
        }
        
        // Geçiş animasyonu
        withAnimation(.easeInOut(duration: 0.5)) {
            // Seçeneğin etkilerini uygula
            viewModel.selectOption(option)
        }
        
        // Geçiş animasyonu tamamlandıktan sonra
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isTransitioning = false
            
            // Bildirim göster
            if let effect = option.effect {
                showNotification(for: effect)
            }
        }
    }
    
    private func updateEffects(for node: StoryNode) {
        // Hava durumu efektlerini güncelle
        showRainEffect = node.weather == .rainy || node.weather == .stormy
        showSnowEffect = node.weather == .snowy
        
        // Mevsim efektlerini güncelle
        if let season = node.season {
            currentSeason = season
            switch season {
            case .autumn:
                showLeafEffect = true
                showFlowerEffect = false
            case .spring:
                showLeafEffect = false
                showFlowerEffect = true
            default:
                showLeafEffect = false
                showFlowerEffect = false
            }
        }
        
        // Efekt yoğunluğunu ayarla
        weatherIntensity = node.weather == .stormy ? 0.8 : 0.5
    }
    
    private func showNotification(for effect: StoryEffects) {
        let notification = GameNotification(
            title: "Değişiklikler",
            message: createEffectMessage(from: effect),
            type: .effect
        )
        
        currentNotification = notification
        withAnimation {
            showNotification = true
        }
        
        // 3 saniye sonra bildirimi kaldır
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showNotification = false
            }
        }
    }
    
    private func createEffectMessage(from effect: StoryEffects) -> String {
        var messages: [String] = []
        
        if let intelligence = effect.intelligenceChange {
            messages.append("Zeka: \(intelligence > 0 ? "+" : "")\(intelligence)")
        }
        if let beauty = effect.beautyChange {
            messages.append("Güzellik: \(beauty > 0 ? "+" : "")\(beauty)")
        }
        if let luck = effect.luckChange {
            messages.append("Şans: \(luck > 0 ? "+" : "")\(luck)")
        }
        if let aura = effect.auraChange {
            messages.append("Aura: \(aura > 0 ? "+" : "")\(aura)")
        }
        if let happiness = effect.happinessChange {
            messages.append("Mutluluk: \(happiness > 0 ? "+" : "")\(happiness)")
        }
        if let stress = effect.stressChange {
            messages.append("Stres: \(stress > 0 ? "+" : "")\(stress)")
        }
        if let karma = effect.karmaChange {
            messages.append("Karma: \(karma > 0 ? "+" : "")\(karma)")
        }
        
        return messages.joined(separator: "\n")
    }
}

struct CharacterInfoView: View {
    let character: Character
    
    var body: some View {
        VStack(spacing: 12) {
            // Temel bilgiler
            HStack {
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(character.age) yaşında • \(character.gender)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(character.country)
                    .font(.headline)
            }
            
            // Özellik çubukları
            AttributeBar(title: "Zeka", value: character.intelligence, color: .blue)
            AttributeBar(title: "Güzellik", value: character.beauty, color: .pink)
            AttributeBar(title: "Şans", value: character.luck, color: .green)
            AttributeBar(title: "Aura", value: character.aura, color: .purple)
            
            // Durum çubukları
            HStack {
                StatusIndicator(title: "Mutluluk", value: character.happiness, icon: "heart.fill", color: .red)
                StatusIndicator(title: "Stres", value: character.stress, icon: "bolt.fill", color: .orange)
                StatusIndicator(title: "Karma", value: character.karma, icon: "yin.yang", color: .gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct AttributeBar: View {
    let title: String
    let value: Int
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: isAnimating ? geometry.size.width * CGFloat(value) / 100 : 0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: isAnimating)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct StatusIndicator: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: isAnimating ? CGFloat(value) / 100 : 0)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.8, dampingFraction: 0.8), value: isAnimating)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            .frame(width: 60, height: 60)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(value)%")
                .font(.caption2)
                .bold()
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct OptionButton: View {
    let option: StoryOption
    let action: () -> Void
    @State private var isHovered = false
    
    var style: OptionStyle {
        option.visualStyle ?? OptionStyle(
            backgroundColor: "#4A90E2",
            textColor: "#FFFFFF",
            borderColor: "#2171C7",
            icon: "arrow.right.circle.fill",
            isGlowing: false,
            isPulsing: false
        )
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option.text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let icon = style.icon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(Color(hex: style.backgroundColor ?? "#4A90E2"))
            .foregroundColor(Color(hex: style.textColor ?? "#FFFFFF"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: style.borderColor ?? "#2171C7"), lineWidth: 2)
            )
            .shadow(radius: isHovered ? 8 : 4)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
        .modifier(GlowModifier(isGlowing: style.isGlowing ?? false))
        .modifier(PulseModifier(isPulsing: style.isPulsing ?? false))
    }
}

struct GlowModifier: ViewModifier {
    let isGlowing: Bool
    
    func body(content: Content) -> some View {
        if isGlowing {
            content
                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                .shadow(color: .white.opacity(0.2), radius: 20, x: 0, y: 0)
        } else {
            content
        }
    }
}

struct PulseModifier: ViewModifier {
    let isPulsing: Bool
    @State private var isPulsed = false
    
    func body(content: Content) -> some View {
        if isPulsing {
            content
                .scaleEffect(isPulsed ? 1.02 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                    value: isPulsed
                )
                .onAppear {
                    isPulsed = true
                }
        } else {
            content
        }
    }
}

struct NotificationView: View {
    let notification: GameNotification
    let dismissAction: () -> Void
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        VStack {
            HStack {
                Text(notification.title)
                    .font(.headline)
                Spacer()
                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(notification.message)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
        .offset(y: offset)
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
    }
}

struct GameNotification {
    let title: String
    let message: String
    let type: NotificationType
    
    enum NotificationType {
        case effect
        case achievement
        case event
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView(character: .preview)
}
