import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary backgrounds
    static let zenWhite = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let zenIce = Color(red: 0.96, green: 0.97, blue: 0.98)

    // Accent colors
    static let zenMint = Color(red: 0.30, green: 0.85, blue: 0.72)        // #4DD9B8 — success / health
    static let zenMintLight = Color(red: 0.85, green: 0.96, blue: 0.93)   // light mint bg
    static let zenBlue = Color(red: 0.33, green: 0.53, blue: 0.85)        // #5487D9 — calm / tech
    static let zenBlueLight = Color(red: 0.88, green: 0.93, blue: 0.98)   // light blue bg
    static let zenOrange = Color(red: 0.96, green: 0.65, blue: 0.32)      // #F5A652 — warning / alert
    static let zenOrangeLight = Color(red: 0.99, green: 0.94, blue: 0.87) // light orange bg
    static let zenRed = Color(red: 0.92, green: 0.34, blue: 0.34)         // danger

    // Text colors
    static let zenTextPrimary = Color(red: 0.13, green: 0.15, blue: 0.20)
    static let zenTextSecondary = Color(red: 0.50, green: 0.53, blue: 0.58)
    static let zenTextTertiary = Color(red: 0.70, green: 0.73, blue: 0.76)

    // Surface
    static let zenCard = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let zenCardDark = Color(red: 0.16, green: 0.17, blue: 0.21)
    static let zenDivider = Color(red: 0.92, green: 0.93, blue: 0.94)
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

// MARK: - Button Styles
struct ZenPrimaryButtonStyle: ButtonStyle {
    var color: Color = .zenMint

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.zenSubheadline())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: 8, y: 4)
            )
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
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.zenMint, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Card Modifier
struct ZenCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? Color.zenCardDark : Color.zenCard)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 12, y: 4)
            )
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
                .background(
                    Circle()
                        .fill(Color.zenMintLight)
                )
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
