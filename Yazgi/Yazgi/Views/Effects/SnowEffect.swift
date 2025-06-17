import SwiftUI

struct Snowflake: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var rotationAngle: Double
    var swayOffset: CGFloat
    var swaySpeed: CGFloat
    var fallSpeed: CGFloat
    var opacity: Double
}

struct SnowEffect: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var timer: Timer?
    let intensity: Double // 0.0 - 1.0
    
    init(intensity: Double = 0.5) {
        self.intensity = intensity
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for flake in snowflakes {
                    let rect = CGRect(
                        x: flake.position.x,
                        y: flake.position.y,
                        width: flake.size,
                        height: flake.size
                    )
                    
                    context.opacity = flake.opacity
                    context.translateBy(x: rect.midX, y: rect.midY)
                    context.rotate(by: .degrees(flake.rotationAngle))
                    context.translateBy(x: -rect.midX, y: -rect.midY)
                    
                    // Kar tanesi şekli
                    let path = Path { path in
                        // Ana daire
                        path.addEllipse(in: rect)
                        
                        // Kristal kolları
                        for angle in stride(from: 0, to: 360, by: 60) {
                            let rad = CGFloat(angle) * .pi / 180
                            let startPoint = CGPoint(
                                x: rect.midX + cos(rad) * flake.size * 0.2,
                                y: rect.midY + sin(rad) * flake.size * 0.2
                            )
                            let endPoint = CGPoint(
                                x: rect.midX + cos(rad) * flake.size * 0.5,
                                y: rect.midY + sin(rad) * flake.size * 0.5
                            )
                            
                            path.move(to: startPoint)
                            path.addLine(to: endPoint)
                        }
                    }
                    
                    context.stroke(path, with: .color(.white), lineWidth: 1)
                    context.fill(path, with: .color(.white.opacity(0.3)))
                }
            }
        }
        .onAppear {
            startSnow()
        }
        .onDisappear {
            stopSnow()
        }
    }
    
    private func startSnow() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateSnow()
        }
    }
    
    private func stopSnow() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateSnow() {
        // Yeni kar taneleri ekle
        let flakeCount = Int(intensity * 2)
        for _ in 0..<flakeCount {
            let flake = Snowflake(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20
                ),
                size: CGFloat.random(in: 5...15),
                rotationAngle: Double.random(in: 0...360),
                swayOffset: 0,
                swaySpeed: CGFloat.random(in: 1...3),
                fallSpeed: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.5...0.9)
            )
            snowflakes.append(flake)
        }
        
        // Mevcut kar tanelerini güncelle
        snowflakes = snowflakes.compactMap { flake in
            var newFlake = flake
            
            // Sallanma hareketi
            newFlake.swayOffset += sin(CACurrentMediaTime() * Double(flake.swaySpeed)) * 0.5
            newFlake.position.x += newFlake.swayOffset
            
            // Düşme hareketi
            newFlake.position.y += flake.fallSpeed
            
            // Dönme hareketi
            newFlake.rotationAngle += 1
            
            // Ekranın dışına çıkan kar tanelerini kaldır
            if newFlake.position.y > UIScreen.main.bounds.height {
                return nil
            }
            return newFlake
        }
    }
}

#Preview {
    ZStack {
        Color.black
        SnowEffect(intensity: 0.7)
    }
    .ignoresSafeArea()
} 