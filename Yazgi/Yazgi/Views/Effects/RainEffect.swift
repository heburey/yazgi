import SwiftUI

struct RainDrop: Identifiable {
    let id = UUID()
    var position: CGPoint
    var length: CGFloat
    var speed: CGFloat
    var opacity: Double
}

struct RainEffect: View {
    @State private var raindrops: [RainDrop] = []
    @State private var timer: Timer?
    let intensity: Double // 0.0 - 1.0
    
    init(intensity: Double = 0.5) {
        self.intensity = intensity
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.1, paused: false)) { timeline in
            Canvas { context, size in
                for drop in raindrops {
                    var path = Path()
                    path.move(to: CGPoint(x: drop.position.x, y: drop.position.y))
                    path.addLine(to: CGPoint(x: drop.position.x, y: drop.position.y + drop.length))
                    
                    context.opacity = drop.opacity
                    context.stroke(path, with: .color(.white), lineWidth: 1)
                }
            }
        }
        .onAppear {
            startRain()
        }
        .onDisappear {
            stopRain()
        }
    }
    
    private func startRain() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateRain()
        }
    }
    
    private func stopRain() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateRain() {
        // Yeni yağmur damlaları ekle
        let dropCount = Int(intensity * 5)
        for _ in 0..<dropCount {
            let drop = RainDrop(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -10
                ),
                length: CGFloat.random(in: 10...20),
                speed: CGFloat.random(in: 5...15),
                opacity: Double.random(in: 0.3...0.7)
            )
            raindrops.append(drop)
        }
        
        // Mevcut damlaları güncelle
        raindrops = raindrops.compactMap { drop in
            var newDrop = drop
            newDrop.position.y += drop.speed
            
            // Ekranın dışına çıkan damlaları kaldır
            if newDrop.position.y > UIScreen.main.bounds.height {
                return nil
            }
            return newDrop
        }
    }
}

#Preview {
    ZStack {
        Color.black
        RainEffect(intensity: 0.7)
    }
    .ignoresSafeArea()
} 