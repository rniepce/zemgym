import Foundation
import SwiftData

// MARK: - Body Area Enum
enum BodyArea: String, Codable, CaseIterable, Identifiable {
    case lombar = "Lombar"
    case joelho = "Joelho"
    case ombro = "Ombro"
    case pescoco = "Pescoço"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .lombar: return "figure.walk"
        case .joelho: return "figure.run"
        case .ombro: return "figure.arms.open"
        case .pescoco: return "person.bust"
        }
    }

    var description: String {
        switch self {
        case .lombar: return "Dor ou sensibilidade na região lombar"
        case .joelho: return "Dor ou sensibilidade nos joelhos"
        case .ombro: return "Dor ou sensibilidade nos ombros"
        case .pescoco: return "Dor ou sensibilidade no pescoço"
        }
    }
}

// MARK: - User Profile Model
@Model
final class UserProfile {
    var name: String
    var restrictionsRaw: [String]
    var onboardingComplete: Bool
    var createdAt: Date

    init(name: String = "", restrictions: [BodyArea] = [], onboardingComplete: Bool = false) {
        self.name = name
        self.restrictionsRaw = restrictions.map { $0.rawValue }
        self.onboardingComplete = onboardingComplete
        self.createdAt = Date()
    }

    var restrictions: [BodyArea] {
        get { restrictionsRaw.compactMap { BodyArea(rawValue: $0) } }
        set { restrictionsRaw = newValue.map { $0.rawValue } }
    }

    func hasRestriction(_ area: BodyArea) -> Bool {
        restrictions.contains(area)
    }
}
