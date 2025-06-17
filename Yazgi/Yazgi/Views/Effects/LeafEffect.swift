import SwiftUI

struct Leaf: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var rotationAngle: Double
    var swayOffset: CGFloat
    var swaySpeed: CGFloat
    var fallSpeed: CGFloat
    var opacity: Double
    var color: Color
}

struct LeafEffect: View {
    @State private var leaves: [Leaf] = []
    @State private var timer: Timer?
    let intensity: Double // 0.0 - 1.0
    let season: Season
    
    init(intensity: Double = 0.5, season: Season = .autumn) {
        self.intensity = intensity
        self.season = season
    }
    
    var leafColors: [Color] {
        switch season {
        case .autumn:
            return [.orange, .red, .yellow, .brown]
        case .spring:
            return [.green, .mint, .teal, .lime]
        case .summer:
            return [.green, .darkGreen, .forestGreen]
        case .winter:
            return [.brown, .darkBrown]
        }
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for leaf in leaves {
                    context.opacity = leaf.opacity
                    context.translateBy(x: leaf.position.x + leaf.size/2, y: leaf.position.y + leaf.size/2)
                    context.rotate(by: .degrees(leaf.rotationAngle))
                    context.translateBy(x: -(leaf.position.x + leaf.size/2), y: -(leaf.position.y + leaf.size/2))
                    
                    // Yaprak şekli
                    let path = Path { path in
                        let rect = CGRect(
                            x: leaf.position.x,
                            y: leaf.position.y,
                            width: leaf.size,
                            height: leaf.size
                        )
                        
                        // Yaprak gövdesi
                        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                        path.addQuadCurve(
                            to: CGPoint(x: rect.maxX, y: rect.midY),
                            control: CGPoint(x: rect.maxX, y: rect.minY)
                        )
                        path.addQuadCurve(
                            to: CGPoint(x: rect.midX, y: rect.maxY),
                            control: CGPoint(x: rect.maxX, y: rect.maxY)
                        )
                        path.addQuadCurve(
                            to: CGPoint(x: rect.minX, y: rect.midY),
                            control: CGPoint(x: rect.minX, y: rect.maxY)
                        )
                        path.addQuadCurve(
                            to: CGPoint(x: rect.midX, y: rect.minY),
                            control: CGPoint(x: rect.minX, y: rect.minY)
                        )
                        
                        // Yaprak damarları
                        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                        
                        let damarlıkSayısı = 3
                        for i in 1...damarlıkSayısı {
                            let y = rect.minY + (rect.height * CGFloat(i) / CGFloat(damarlıkSayısı + 1))
                            path.move(to: CGPoint(x: rect.midX, y: y))
                            path.addQuadCurve(
                                to: CGPoint(x: rect.maxX - 5, y: y),
                                control: CGPoint(x: rect.midX + rect.width/4, y: y - 5)
                            )
                            path.move(to: CGPoint(x: rect.midX, y: y))
                            path.addQuadCurve(
                                to: CGPoint(x: rect.minX + 5, y: y),
                                control: CGPoint(x: rect.midX - rect.width/4, y: y - 5)
                            )
                        }
                    }
                    
                    context.stroke(path, with: .color(leaf.color.opacity(0.8)), lineWidth: 1)
                    context.fill(path, with: .color(leaf.color.opacity(0.6)))
                }
            }
        }
        .onAppear {
            startLeaves()
        }
        .onDisappear {
            stopLeaves()
        }
    }
    
    private func startLeaves() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateLeaves()
        }
    }
    
    private func stopLeaves() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateLeaves() {
        // Yeni yapraklar ekle
        let leafCount = Int(intensity * 2)
        for _ in 0..<leafCount {
            let leaf = Leaf(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20
                ),
                size: CGFloat.random(in: 20...40),
                rotationAngle: Double.random(in: 0...360),
                swayOffset: 0,
                swaySpeed: CGFloat.random(in: 1...3),
                fallSpeed: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.6...0.9),
                color: leafColors.randomElement() ?? .brown
            )
            leaves.append(leaf)
        }
        
        // Mevcut yaprakları güncelle
        leaves = leaves.compactMap { leaf in
            var newLeaf = leaf
            
            // Sallanma hareketi
            newLeaf.swayOffset += sin(CACurrentMediaTime() * Double(leaf.swaySpeed)) * 1.5
            newLeaf.position.x += newLeaf.swayOffset
            
            // Düşme hareketi
            newLeaf.position.y += leaf.fallSpeed
            
            // Dönme hareketi
            newLeaf.rotationAngle += Double.random(in: -5...5)
            
            // Ekranın dışına çıkan yaprakları kaldır
            if newLeaf.position.y > UIScreen.main.bounds.height {
                return nil
            }
            return newLeaf
        }
    }
}

// Using Season from SharedTypes.swift to avoid ambiguity

extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0)
    static let forestGreen = Color(red: 0.133, green: 0.545, blue: 0.133)
    static let lime = Color(red: 0.196, green: 0.804, blue: 0.196)
    static let darkBrown = Color(red: 0.396, green: 0.263, blue: 0.129)
}

    #Preview {
        ZStack {
            Color.black
            LeafEffect(intensity: 0.7, season: Season.autumn)
        }
        .ignoresSafeArea()
    } 