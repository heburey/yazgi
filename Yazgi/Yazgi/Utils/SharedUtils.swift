import SwiftUI

// MARK: - Formatters
struct Formatters {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    static func formatCurrency(_ amount: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: amount)) ?? "₺0"
    }
    
    static func formatPercent(_ value: Double) -> String {
        percentFormatter.string(from: NSNumber(value: value)) ?? "0%"
    }
    
    static func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    static func formatShortDate(_ date: Date) -> String {
        shortDateFormatter.string(from: date)
    }
}

// MARK: - UI Components
struct ProgressBar: View {
    let value: Double
    let maxValue: Double
    let color: Color
    let height: CGFloat
    let showText: Bool
    
    init(value: Double, maxValue: Double = 100, color: Color = .blue, height: CGFloat = 8, showText: Bool = false) {
        self.value = value
        self.maxValue = maxValue
        self.color = color
        self.height = height
        self.showText = showText
    }
    
    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: min(CGFloat(value / maxValue) * geometry.size.width, geometry.size.width))
                }
            }
            .frame(height: height)
            .cornerRadius(height / 2)
            
            if showText {
                Text("\(Int(value))/\(Int(maxValue))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StatusIndicator: View {
    let icon: String
    let value: Int
    let maxValue: Int
    let color: Color
    let showValue: Bool
    
    init(icon: String, value: Int, maxValue: Int = 100, color: Color = .blue, showValue: Bool = true) {
        self.icon = icon
        self.value = value
        self.maxValue = maxValue
        self.color = color
        self.showValue = showValue
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 4)
                
                Circle()
                    .trim(from: 0, to: CGFloat(value) / CGFloat(maxValue))
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            .frame(width: 40, height: 40)
            
            if showValue {
                Text("\(value)%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AttributeRow: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundColor(color)
            
            Spacer()
            
            ProgressBar(value: Double(value), color: color, showText: true)
                .frame(width: 100)
        }
        .padding(.vertical, 4)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String?
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

struct Badge: View {
    let text: String
    let color: Color
    let icon: String?
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption2)
            }
            
            Text(text)
                .font(.caption2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .cornerRadius(8)
    }
}

// MARK: - Extensions
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
    }
    
    func glowEffect(color: Color = .blue, radius: CGFloat = 10) -> some View {
        self
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.2), radius: radius * 2, x: 0, y: 0)
    }
}

// MARK: - Preview Helpers
struct SharedUtils_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ProgressBar(value: 75, color: .blue, showText: true)
                .frame(width: 200)
            
            StatusIndicator(icon: "heart.fill", value: 85, color: .red)
            
            AttributeRow(title: "Zeka", value: 80, icon: "brain", color: .blue)
                .padding(.horizontal)
            
            InfoRow(title: "Meslek", value: "Yazılım Mühendisi", icon: "briefcase.fill")
                .padding(.horizontal)
            
            Badge(text: "Yeni Başarım", color: .green, icon: "star.fill")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 