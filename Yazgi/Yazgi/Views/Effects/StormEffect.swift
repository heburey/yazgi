import SwiftUI

struct StormEffect: View {
    let intensity: Double // 0.0-1.0 arası
    @State private var isAnimating = false
    @State private var lightningOpacity = 0.0
    @State private var lastLightningTime = Date()
    @State private var raindrops: [Raindrop] = []
    @State private var cloudCover: Double = 0.0
    @State private var windIntensity: Double = 0.0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    struct Raindrop: Identifiable {
        let id = UUID()
        var position: CGPoint
        var length: CGFloat
        var speed: Double
        var opacity: Double
        var angle: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Bulut katmanı
                CloudLayer(opacity: cloudCover)
                
                // Yağmur damlaları
                ForEach(raindrops) { drop in
                    Path { path in
                        path.move(to: CGPoint(x: drop.position.x, y: drop.position.y))
                        path.addLine(to: CGPoint(
                            x: drop.position.x + drop.length * cos(drop.angle),
                            y: drop.position.y + drop.length * sin(drop.angle)
                        ))
                    }
                    .stroke(Color.white.opacity(drop.opacity), lineWidth: 1)
                }
                
                // Şimşek efekti
                Color.white
                    .opacity(lightningOpacity)
                    .ignoresSafeArea()
            }
            .onAppear {
                setupStorm(in: geometry.size)
                startStorm()
            }
            .onReceive(timer) { _ in
                updateStorm(in: geometry.size)
                if shouldTriggerLightning() {
                    triggerLightning()
                }
            }
        }
    }
    
    private func setupStorm(in size: CGSize) {
        // Bulut örtüsünü ayarla
        withAnimation(.easeIn(duration: 2.0)) {
            cloudCover = 0.3 + 0.4 * intensity
        }
        
        // Rüzgar şiddetini ayarla
        windIntensity = intensity * 0.5
        
        // Yağmur damlalarını oluştur
        let dropCount = Int(100 * intensity)
        raindrops = (0..<dropCount).map { _ in
            createRaindrop(in: size)
        }
    }
    
    private func createRaindrop(in size: CGSize) -> Raindrop {
        let windAngle = Double.pi / 2 + (windIntensity * Double.random(in: -0.3...0.3))
        
        return Raindrop(
            position: CGPoint(
                x: CGFloat.random(in: -20...size.width + 20),
                y: CGFloat.random(in: -100...size.height)
            ),
            length: CGFloat.random(in: 10...20),
            speed: Double.random(in: 400...600) * intensity,
            opacity: Double.random(in: 0.2...0.4),
            angle: windAngle
        )
    }
    
    private func updateStorm(in size: CGSize) {
        // Rüzgar açısını güncelle
        let baseWindAngle = Double.pi / 2
        let windVariation = sin(Date().timeIntervalSince1970 * 0.5) * windIntensity
        
        for i in raindrops.indices {
            var drop = raindrops[i]
            
            // Yağmur damlasının pozisyonunu güncelle
            let currentAngle = baseWindAngle + windVariation
            let dx = drop.speed * 0.05 * cos(currentAngle)
            let dy = drop.speed * 0.05 * sin(currentAngle)
            
            drop.position.x += CGFloat(dx)
            drop.position.y += CGFloat(dy)
            drop.angle = currentAngle
            
            // Ekran dışına çıkan damlaları yeniden konumlandır
            if drop.position.y > size.height || drop.position.x < -20 || drop.position.x > size.width + 20 {
                drop = createRaindrop(in: size)
                drop.position.y = -drop.length
            }
            
            raindrops[i] = drop
        }
        
        // Bulut örtüsünü güncelle
        let targetCloudCover = 0.3 + 0.4 * intensity + 0.1 * sin(Date().timeIntervalSince1970 * 0.2)
        withAnimation(.easeInOut(duration: 0.5)) {
            cloudCover += (targetCloudCover - cloudCover) * 0.1
        }
    }
    
    private func shouldTriggerLightning() -> Bool {
        guard -lastLightningTime.timeIntervalSinceNow > 3.0 else { return false }
        return Double.random(in: 0...1) < 0.01 * intensity
    }
    
    private func triggerLightning() {
        lastLightningTime = Date()
        
        // İlk parlama
        withAnimation(.easeIn(duration: 0.1)) {
            lightningOpacity = Double.random(in: 0.3...0.7) * intensity
        }
        
        // İkinci parlama
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.1)) {
                lightningOpacity = 0
            }
        }
        
        // Üçüncü parlama (bazen)
        if Double.random(in: 0...1) < 0.3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeIn(duration: 0.05)) {
                    lightningOpacity = Double.random(in: 0.1...0.3) * intensity
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeOut(duration: 0.1)) {
                        lightningOpacity = 0
                    }
                }
            }
        }
        
        // Gök gürültüsü sesi
        playThunderSound(delay: Double.random(in: 0.2...0.5))
    }
    
    private func playThunderSound(delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Burada gök gürültüsü sesi çalınacak
            // SoundManager.shared.playSound("thunder", volume: Float(intensity))
        }
    }
    
    private func startStorm() {
        isAnimating = true
    }
}

struct CloudLayer: View {
    let opacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Arka plan bulutları
                ForEach(0..<5) { i in
                    Cloud(size: CGSize(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2))
                        .fill(Color.gray.opacity(opacity * 0.8))
                        .offset(x: geometry.size.width * [0.1, 0.3, 0.5, 0.7, 0.9][i],
                                y: geometry.size.height * [0.1, 0.2, 0.15, 0.25, 0.1][i])
                }
                
                // Ön plan bulutları
                ForEach(0..<3) { i in
                    Cloud(size: CGSize(width: geometry.size.width * 0.6, height: geometry.size.height * 0.3))
                        .fill(Color.gray.opacity(opacity))
                        .offset(x: geometry.size.width * [0.2, 0.5, 0.8][i],
                                y: geometry.size.height * [0.3, 0.2, 0.25][i])
                }
            }
        }
    }
}

struct Cloud: Shape {
    let size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = size.width
        let height = size.height
        let centerY = height / 2
        
        // Bulut şeklini oluştur
        path.move(to: CGPoint(x: width * 0.2, y: centerY))
        
        // Alt kısım
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: centerY),
            control1: CGPoint(x: width * 0.4, y: height),
            control2: CGPoint(x: width * 0.6, y: height)
        )
        
        // Üst kısım
        path.addCurve(
            to: CGPoint(x: width * 0.2, y: centerY),
            control1: CGPoint(x: width * 0.6, y: 0),
            control2: CGPoint(x: width * 0.4, y: 0)
        )
        
        return path
    }
}

struct StormEffect_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            StormEffect(intensity: 0.8)
        }
        .ignoresSafeArea()
    }
} 