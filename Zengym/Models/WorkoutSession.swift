import Foundation
import SwiftData

// MARK: - Effort Feedback
enum EffortFeedback: String, Codable, CaseIterable {
    case leve = "Leve"
    case ideal = "Ideal"
    case muitoPesado = "Muito Pesado"

    var emoji: String {
        switch self {
        case .leve: return "😊"
        case .ideal: return "💪"
        case .muitoPesado: return "😰"
        }
    }

    var label: String {
        switch self {
        case .leve: return "Leve"
        case .ideal: return "Ideal"
        case .muitoPesado: return "Muito Pesado"
        }
    }

    var color: String {
        switch self {
        case .leve: return "zenBlue"
        case .ideal: return "zenMint"
        case .muitoPesado: return "zenOrange"
        }
    }
}

// MARK: - Exercise Log (Single exercise within a session)
@Model
final class ExerciseLog {
    var exerciseId: String
    var exerciseName: String
    var muscleGroupRaw: String
    var sets: Int
    var reps: Int
    var weight: Double
    var effortRaw: String?
    var completedAt: Date

    @Relationship(inverse: \WorkoutSession.exerciseLogs)
    var session: WorkoutSession?

    init(exerciseId: String, exerciseName: String, muscleGroup: MuscleGroup, sets: Int = 0, reps: Int = 0, weight: Double = 0) {
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.muscleGroupRaw = muscleGroup.rawValue
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.completedAt = Date()
    }

    var muscleGroup: MuscleGroup? {
        MuscleGroup(rawValue: muscleGroupRaw)
    }

    var effort: EffortFeedback? {
        get { effortRaw.flatMap { EffortFeedback(rawValue: $0) } }
        set { effortRaw = newValue?.rawValue }
    }

    var totalVolume: Double {
        Double(sets) * Double(reps) * weight
    }
}

// MARK: - Workout Session
@Model
final class WorkoutSession {
    var date: Date
    var durationMinutes: Int
    var notes: String
    var exerciseLogs: [ExerciseLog]

    init(durationMinutes: Int = 0) {
        self.date = Date()
        self.durationMinutes = durationMinutes
        self.notes = ""
        self.exerciseLogs = []
    }

    var totalVolume: Double {
        exerciseLogs.reduce(0) { $0 + $1.totalVolume }
    }

    var exerciseCount: Int {
        exerciseLogs.count
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}
