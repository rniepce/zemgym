import Foundation

// MARK: - Muscle Group
enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case peito = "Peito"
    case costas = "Costas"
    case ombros = "Ombros"
    case biceps = "Bíceps"
    case triceps = "Tríceps"
    case quadriceps = "Quadríceps"
    case posteriores = "Posteriores"
    case gluteos = "Glúteos"
    case panturrilha = "Panturrilha"
    case abdomen = "Abdômen"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .peito: return "figure.strengthtraining.traditional"
        case .costas: return "figure.rowing"
        case .ombros: return "figure.arms.open"
        case .biceps: return "figure.strengthtraining.functional"
        case .triceps: return "figure.strengthtraining.functional"
        case .quadriceps: return "figure.walk"
        case .posteriores: return "figure.walk"
        case .gluteos: return "figure.walk"
        case .panturrilha: return "figure.walk"
        case .abdomen: return "figure.core.training"
        }
    }
}

// MARK: - Equipment Type
enum EquipmentType: String, Codable {
    case maquina = "Máquina"
    case polia = "Polia"
    case pesoLivre = "Peso Livre"
    case corporal = "Corporal"
    case banco = "Banco"
}

// MARK: - Exercise Model (Decoded from JSON)
struct Exercise: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let muscleGroup: MuscleGroup
    let equipment: EquipmentType
    let sets: Int
    let reps: String
    let restSeconds: Int
    let durationMinutes: Int
    let contraindications: [BodyArea]
    let checklist: [String]
    let dangerAlert: String
    let animationSymbol: String
    let instructions: String

    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Exercise Loader
struct ExerciseLoader {
    static func loadAll() -> [Exercise] {
        guard let url = Bundle.main.url(forResource: "ExerciseDatabase", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let exercises = try? JSONDecoder().decode([Exercise].self, from: data) else {
            print("⚠️ Failed to load ExerciseDatabase.json")
            return []
        }
        return exercises
    }

    static func safeExercises(for restrictions: [BodyArea]) -> [Exercise] {
        loadAll().filter { exercise in
            !exercise.contraindications.contains(where: { restrictions.contains($0) })
        }
    }
}
