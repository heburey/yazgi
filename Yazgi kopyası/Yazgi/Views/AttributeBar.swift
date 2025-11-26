import SwiftUI

struct AttributeBar: View {
    let label: String
    let value: Int

    private var barColor: Color {
        switch value {
        case 0...34: return .red
        case 35...64: return .orange
        default: return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("%\(value)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.tertiarySystemFill))
                    .frame(height: 10)

                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    barColor.opacity(0.7),
                                    barColor
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: max(14, geometry.size.width * CGFloat(min(max(value, 0), 100)) / 100),
                            height: 10
                        )
                }
                .frame(height: 10)
            }
        }
    }
}

struct AttributeBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 14) {
            AttributeBar(label: "Sağlık", value: 90)
            AttributeBar(label: "Mutluluk", value: 65)
            AttributeBar(label: "Network", value: 25)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
