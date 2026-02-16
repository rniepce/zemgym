import SwiftUI

// MARK: - Native Liquid Glass Wrapper
// Wraps Apple's native .glassEffect() API for convenient use across the app.
// Uses the real Liquid Glass material — not a custom blur approximation.

extension View {
    /// Apply native Liquid Glass effect to a view.
    /// Use sparingly on key functional elements only (Apple guidance).
    func zenGlass(cornerRadius: CGFloat = 20, isInteractive: Bool = false) -> some View {
        self
            .glassEffect(.regular.interactive(isInteractive), in: .rect(cornerRadius: cornerRadius))
    }

    /// Prominent Liquid Glass variant — slightly more opaque, for primary actions.
    func zenGlassProminent(cornerRadius: CGFloat = 20) -> some View {
        self
            .glassEffect(.regular.interactive(true), in: .rect(cornerRadius: cornerRadius))
    }
}
