import Foundation

// MARK: - Workout Split Type
enum WorkoutSplit: String, CaseIterable {
    case upperBody = "Superior"     // Peito, Costas, Ombros, Bíceps, Tríceps
    case lowerBody = "Inferior"     // Quadríceps, Posteriores, Glúteos, Panturrilha
    case fullBody = "Corpo Inteiro" // Mix of both

    var muscleGroups: [MuscleGroup] {
        switch self {
        case .upperBody:
            return [.peito, .costas, .ombros, .biceps, .triceps]
        case .lowerBody:
            return [.quadriceps, .posteriores, .gluteos, .panturrilha]
        case .fullBody:
            return MuscleGroup.allCases
        }
    }
}

// MARK: - Workout Engine
struct WorkoutEngine {

    private static let allExercises: [Exercise] = ExerciseLoader.loadAll()

    /// Generates a safe, balanced workout based on duration and user restrictions.
    static func generateWorkout(
        duration: Int,
        restrictions: [BodyArea],
        split: WorkoutSplit = .fullBody
    ) -> [Exercise] {
        // 1. Filter out contraindicated exercises
        let safeExercises = allExercises.filter { exercise in
            !exercise.contraindications.contains(where: { restrictions.contains($0) })
        }

        // 2. Filter by the desired muscle group split
        let splitExercises = safeExercises.filter { exercise in
            split.muscleGroups.contains(exercise.muscleGroup)
        }

        // 3. Group by muscle group for balanced selection
        var grouped: [MuscleGroup: [Exercise]] = [:]
        for exercise in splitExercises {
            grouped[exercise.muscleGroup, default: []].append(exercise)
        }

        // 4. Shuffle each group for variety
        for key in grouped.keys {
            grouped[key]?.shuffle()
        }

        // 5. Build workout within time budget
        var workout: [Exercise] = []
        var remainingMinutes = duration
        var usedMuscleGroups: Set<MuscleGroup> = []

        // First pass: pick one exercise per muscle group for balance
        let orderedGroups = split.muscleGroups.filter { grouped[$0] != nil }
        for group in orderedGroups {
            guard let exercises = grouped[group], !exercises.isEmpty else { continue }
            if let chosen = exercises.first, chosen.durationMinutes <= remainingMinutes {
                workout.append(chosen)
                remainingMinutes -= chosen.durationMinutes
                usedMuscleGroups.insert(group)
            }
        }

        // Second pass: fill remaining time with extra exercises from groups that have more options
        for group in orderedGroups.shuffled() {
            guard let exercises = grouped[group] else { continue }
            for exercise in exercises {
                if remainingMinutes <= 2 { break }
                if !workout.contains(exercise) && exercise.durationMinutes <= remainingMinutes {
                    workout.append(exercise)
                    remainingMinutes -= exercise.durationMinutes
                    break
                }
            }
        }

        return workout
    }

    /// Returns a smart split recommendation based on day and recent workouts.
    static func recommendedSplit(lastSplit: WorkoutSplit?) -> WorkoutSplit {
        guard let last = lastSplit else { return .fullBody }
        switch last {
        case .fullBody: return .upperBody
        case .upperBody: return .lowerBody
        case .lowerBody: return .upperBody
        }
    }

    /// Swaps an exercise for another targeting the same muscle group.
    static func swapExercise(
        current: Exercise,
        inWorkout workout: [Exercise],
        restrictions: [BodyArea]
    ) -> Exercise? {
        let safeExercises = allExercises.filter { exercise in
            !exercise.contraindications.contains(where: { restrictions.contains($0) })
        }

        let alternatives = safeExercises.filter { exercise in
            exercise.muscleGroup == current.muscleGroup &&
            exercise.id != current.id &&
            !workout.contains(exercise)
        }

        return alternatives.randomElement()
    }
}
