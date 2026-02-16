import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary backgrounds
    static let zenWhite = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let zenIce = Color(red: 0.96, green: 0.97, blue: 0.98)

    // Accent colors
    static let zenMint = Color(red: 0.30, green: 0.85, blue: 0.72)        // #4DD9B8
    static let zenMintLight = Color(red: 0.85, green: 0.96, blue: 0.93)
    static let zenBlue = Color(red: 0.33, green: 0.53, blue: 0.85)        // #5487D9
    static let zenBlueLight = Color(red: 0.88, green: 0.93, blue: 0.98)
    static let zenOrange = Color(red: 0.96, green: 0.65, blue: 0.32)      // #F5A652
    static let zenOrangeLight = Color(red: 0.99, green: 0.94, blue: 0.87)
    static let zenRed = Color(red: 0.92, green: 0.34, blue: 0.34)

    // Text colors
    static let zenTextPrimary = Color(red: 0.10, green: 0.12, blue: 0.18)
    static let zenTextSecondary = Color(red: 0.40, green: 0.43, blue: 0.48)
    static let zenTextTertiary = Color(red: 0.60, green: 0.63, blue: 0.66)

    // Surface
    static let zenCard = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let zenCardDark = Color(red: 0.16, green: 0.17, blue: 0.21)
    static let zenDivider = Color(red: 0.92, green: 0.93, blue: 0.94)

    // Gradients
    static let zenGradientMintBlue = LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let zenGradientOrangeRed = LinearGradient(colors: [.zenOrange, .zenRed], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - Typography (SF Rounded)
extension Font {
    static func zenTitle() -> Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }

    static func zenHeadline() -> Font {
        .system(size: 22, weight: .semibold, design: .rounded)
    }

    static func zenSubheadline() -> Font {
        .system(size: 17, weight: .medium, design: .rounded)
    }

    static func zenBody() -> Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }

    static func zenCaption() -> Font {
        .system(size: 13, weight: .medium, design: .rounded)
    }

    static func zenLargeNumber() -> Font {
        .system(size: 48, weight: .bold, design: .rounded)
    }

    static func zenHuge() -> Font {
        .system(size: 64, weight: .heavy, design: .rounded)
    }
}

// MARK: - Button Styles (Native Liquid Glass)
struct ZenPrimaryButtonStyle: ButtonStyle {
    var color: Color = .zenMint

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zenSubheadline())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(color, in: .rect(cornerRadius: 16))
            .glassEffect(.regular.interactive(true), in: .rect(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ZenSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zenSubheadline())
            .foregroundColor(.zenMint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(.clear, in: .rect(cornerRadius: 16))
            .glassEffect(.regular, in: .rect(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Card Modifier (Liquid Glass)
struct ZenCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

extension View {
    func zenCard() -> some View {
        modifier(ZenCardModifier())
    }
}

// MARK: - Stepper Button (Giant +/-)
struct ZenStepperButton: View {
    let symbol: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.zenMint)
                .frame(width: 64, height: 64)
                .glassEffect(.regular.interactive(true), in: .circle)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pill Badge
struct ZenPillBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.zenCaption())
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color.opacity(0.12))
            )
    }
}
