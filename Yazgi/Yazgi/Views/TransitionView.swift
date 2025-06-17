import SwiftUI

struct TransitionView<Content: View>: View {
    let content: Content
    @Binding var isPresented: Bool
    let type: TransitionType
    let duration: Double
    
    init(
        isPresented: Binding<Bool>,
        type: TransitionType = .fade,
        duration: Double = 0.5,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.type = type
        self.duration = duration
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                content
                    .opacity(isPresented ? 1 : 0)
                    .blur(radius: isPresented ? 0 : 10)
                    .scaleEffect(isPresented ? 1 : type.initialScale)
                    .offset(type.offset(for: isPresented, in: geometry.size))
                    .rotation3DEffect(
                        type.rotation(for: isPresented),
                        axis: type.rotationAxis
                    )
            }
            .animation(.easeInOut(duration: duration), value: isPresented)
        }
    }
}

enum TransitionType {
    case fade
    case slide(Edge)
    case scale
    case flip
    case rotate
    case dream
    case dramatic
    
    var initialScale: CGFloat {
        switch self {
        case .scale:
            return 0.8
        case .dramatic:
            return 1.2
        case .dream:
            return 1.1
        default:
            return 1.0
        }
    }
    
    func offset(for isPresented: Bool, in size: CGSize) -> CGSize {
        switch self {
        case .slide(let edge):
            switch edge {
            case .top:
                return CGSize(width: 0, height: isPresented ? 0 : -size.height)
            case .bottom:
                return CGSize(width: 0, height: isPresented ? 0 : size.height)
            case .leading:
                return CGSize(width: isPresented ? 0 : -size.width, height: 0)
            case .trailing:
                return CGSize(width: isPresented ? 0 : size.width, height: 0)
            }
        case .dramatic:
            return CGSize(
                width: isPresented ? 0 : size.width * 0.3,
                height: isPresented ? 0 : size.height * 0.2
            )
        case .dream:
            return CGSize(
                width: isPresented ? 0 : sin(Date().timeIntervalSinceReferenceDate) * 10,
                height: isPresented ? 0 : cos(Date().timeIntervalSinceReferenceDate) * 10
            )
        default:
            return .zero
        }
    }
    
    func rotation(for isPresented: Bool) -> Angle {
        switch self {
        case .flip:
            return .degrees(isPresented ? 0 : 180)
        case .rotate:
            return .degrees(isPresented ? 0 : 360)
        case .dramatic:
            return .degrees(isPresented ? 0 : -15)
        default:
            return .zero
        }
    }
    
    var rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
        switch self {
        case .flip:
            return (0, 1, 0)
        case .rotate:
            return (0, 0, 1)
        case .dramatic:
            return (0, 0, 1)
        default:
            return (0, 0, 0)
        }
    }
}

struct TransitionModifier: ViewModifier {
    let type: TransitionType
    let duration: Double
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        TransitionView(
            isPresented: $isPresented,
            type: type,
            duration: duration
        ) {
            content
        }
    }
}

extension View {
    func transition(
        type: TransitionType,
        duration: Double = 0.5,
        isPresented: Binding<Bool>
    ) -> some View {
        modifier(TransitionModifier(
            type: type,
            duration: duration,
            isPresented: isPresented
        ))
    }
}

// MARK: - Preview
struct TransitionView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isPresented = false
        
        var body: some View {
            VStack {
                Button("Toggle Transition") {
                    isPresented.toggle()
                }
                .padding()
                
                TransitionView(
                    isPresented: $isPresented,
                    type: .dramatic,
                    duration: 1.0
                ) {
                    ZStack {
                        Color.blue
                        Text("Dramatic Transition")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .frame(height: 200)
                .cornerRadius(20)
                .padding()
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
} 