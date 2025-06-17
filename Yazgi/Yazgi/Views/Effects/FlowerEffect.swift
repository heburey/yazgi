import SwiftUI

struct FlowerPetal: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var rotationAngle: Double
    var swayOffset: CGFloat
    var swaySpeed: CGFloat
    var fallSpeed: CGFloat
    var opacity: Double
    var color: Color
    var type: PetalType
}

enum PetalType {
    case sakura
    case rose
    case daisy
    case tulip
    
    var shape: (Path, CGRect) -> Void {
        switch self {
        case .sakura:
            return { path, rect in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addCurve(
                    to: CGPoint(x: rect.maxX, y: rect.midY),
                    control1: CGPoint(x: rect.midX + rect.width/4, y: rect.minY),
                    control2: CGPoint(x: rect.maxX, y: rect.minY + rect.height/4)
                )
                path.addCurve(
                    to: CGPoint(x: rect.midX, y: rect.maxY),
                    control1: CGPoint(x: rect.maxX, y: rect.midY + rect.height/4),
                    control2: CGPoint(x: rect.midX + rect.width/4, y: rect.maxY)
                )
                path.addCurve(
                    to: CGPoint(x: rect.minX, y: rect.midY),
                    control1: CGPoint(x: rect.midX - rect.width/4, y: rect.maxY),
                    control2: CGPoint(x: rect.minX, y: rect.midY + rect.height/4)
                )
                path.addCurve(
                    to: CGPoint(x: rect.midX, y: rect.minY),
                    control1: CGPoint(x: rect.minX, y: rect.minY + rect.height/4),
                    control2: CGPoint(x: rect.midX - rect.width/4, y: rect.minY)
                )
            }
        case .rose:
            return { path, rect in
                let petalWidth = rect.width * 0.4
                let petalHeight = rect.height * 0.6
                
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addQuadCurve(
                    to: CGPoint(x: rect.midX + petalWidth, y: rect.midY),
                    control: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.3)
                )
                path.addQuadCurve(
                    to: CGPoint(x: rect.midX, y: rect.minY + petalHeight),
                    control: CGPoint(x: rect.midX + petalWidth * 0.8, y: rect.maxY)
                )
                path.addQuadCurve(
                    to: CGPoint(x: rect.midX - petalWidth, y: rect.midY),
                    control: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.3)
                )
                path.addQuadCurve(
                    to: CGPoint(x: rect.midX, y: rect.minY),
                    control: CGPoint(x: rect.midX - petalWidth * 0.8, y: rect.minY)
                )
            }
        case .daisy:
            return { path, rect in
                let petalCount = 8
                let radius = min(rect.width, rect.height) / 2
                let center = CGPoint(x: rect.midX, y: rect.midY)
                
                for i in 0..<petalCount {
                    let angle = Double(i) * .pi * 2 / Double(petalCount)
                    let startPoint = CGPoint(
                        x: center.x + cos(angle) * radius * 0.3,
                        y: center.y + sin(angle) * radius * 0.3
                    )
                    let endPoint = CGPoint(
                        x: center.x + cos(angle) * radius,
                        y: center.y + sin(angle) * radius
                    )
                    let controlPoint1 = CGPoint(
                        x: center.x + cos(angle - 0.3) * radius * 0.8,
                        y: center.y + sin(angle - 0.3) * radius * 0.8
                    )
                    let controlPoint2 = CGPoint(
                        x: center.x + cos(angle + 0.3) * radius * 0.8,
                        y: center.y + sin(angle + 0.3) * radius * 0.8
                    )
                    
                    path.move(to: startPoint)
                    path.addQuadCurve(to: endPoint, control: controlPoint1)
                    path.addQuadCurve(to: startPoint, control: controlPoint2)
                }
            }
        case .tulip:
            return { path, rect in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addCurve(
                    to: CGPoint(x: rect.maxX, y: rect.midY + rect.height * 0.1),
                    control1: CGPoint(x: rect.midX + rect.width * 0.4, y: rect.minY),
                    control2: CGPoint(x: rect.maxX, y: rect.midY - rect.height * 0.2)
                )
                path.addCurve(
                    to: CGPoint(x: rect.midX, y: rect.maxY),
                    control1: CGPoint(x: rect.maxX, y: rect.maxY - rect.height * 0.2),
                    control2: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.maxY)
                )
                path.addCurve(
                    to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 0.1),
                    control1: CGPoint(x: rect.midX - rect.width * 0.2, y: rect.maxY),
                    control2: CGPoint(x: rect.minX, y: rect.maxY - rect.height * 0.2)
                )
                path.addCurve(
                    to: CGPoint(x: rect.midX, y: rect.minY),
                    control1: CGPoint(x: rect.minX, y: rect.midY - rect.height * 0.2),
                    control2: CGPoint(x: rect.midX - rect.width * 0.4, y: rect.minY)
                )
            }
        }
    }
}

struct FlowerEffect: View {
    @State private var petals: [FlowerPetal] = []
    @State private var timer: Timer?
    let intensity: Double // 0.0 - 1.0
    let flowerType: PetalType
    
    init(intensity: Double = 0.5, flowerType: PetalType = .sakura) {
        self.intensity = intensity
        self.flowerType = flowerType
    }
    
    var petalColors: [Color] {
        switch flowerType {
        case .sakura:
            return [Color(red: 0.996, green: 0.878, blue: 0.918),
                   Color(red: 1.0, green: 0.757, blue: 0.812),
                   Color(red: 0.996, green: 0.659, blue: 0.718)]
        case .rose:
            return [.red, .pink, Color(red: 0.937, green: 0.325, blue: 0.314)]
        case .daisy:
            return [.white, Color(red: 1.0, green: 0.98, blue: 0.804)]
        case .tulip:
            return [.red, .pink, .purple, .orange]
        }
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for petal in petals {
                    context.opacity = petal.opacity
                    context.translateBy(x: petal.position.x + petal.size/2, y: petal.position.y + petal.size/2)
                    context.rotate(by: .degrees(petal.rotationAngle))
                    context.translateBy(x: -(petal.position.x + petal.size/2), y: -(petal.position.y + petal.size/2))
                    
                    let rect = CGRect(
                        x: petal.position.x,
                        y: petal.position.y,
                        width: petal.size,
                        height: petal.size
                    )
                    
                    let path = Path { path in
                        petal.type.shape(path, rect)
                    }
                    
                    context.stroke(path, with: .color(petal.color.opacity(0.8)), lineWidth: 1)
                    context.fill(path, with: .color(petal.color.opacity(0.6)))
                }
            }
        }
        .onAppear {
            startPetals()
        }
        .onDisappear {
            stopPetals()
        }
    }
    
    private func startPetals() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updatePetals()
        }
    }
    
    private func stopPetals() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updatePetals() {
        // Yeni yapraklar ekle
        let petalCount = Int(intensity * 2)
        for _ in 0..<petalCount {
            let petal = FlowerPetal(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20
                ),
                size: CGFloat.random(in: 15...30),
                rotationAngle: Double.random(in: 0...360),
                swayOffset: 0,
                swaySpeed: CGFloat.random(in: 1...3),
                fallSpeed: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.6...0.9),
                color: petalColors.randomElement() ?? .pink,
                type: flowerType
            )
            petals.append(petal)
        }
        
        // Mevcut yaprakları güncelle
        petals = petals.compactMap { petal in
            var newPetal = petal
            
            // Sallanma hareketi
            newPetal.swayOffset += sin(CACurrentMediaTime() * Double(petal.swaySpeed)) * 1.5
            newPetal.position.x += newPetal.swayOffset
            
            // Düşme hareketi
            newPetal.position.y += petal.fallSpeed
            
            // Dönme hareketi
            newPetal.rotationAngle += Double.random(in: -5...5)
            
            // Ekranın dışına çıkan yaprakları kaldır
            if newPetal.position.y > UIScreen.main.bounds.height {
                return nil
            }
            return newPetal
        }
    }
}

#Preview {
    ZStack {
        Color.black
        FlowerEffect(intensity: 0.7, flowerType: .sakura)
    }
    .ignoresSafeArea()
} 