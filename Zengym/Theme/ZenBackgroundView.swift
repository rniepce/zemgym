import SwiftUI

// MARK: - Zen Background View
// Simple, clean background that lets Liquid Glass shine.
// No animated blur circles — Liquid Glass handles the visual interest.

struct ZenBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            } else {
                Color.zenIce.ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ZenBackgroundView()
}
