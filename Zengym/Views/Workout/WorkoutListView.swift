import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var exercises: [Exercise]
    let duration: Int
    let profile: UserProfile
    @State private var activeExerciseIndex: Int?
    @State private var showActiveWorkout = false
    @State private var workoutSession: WorkoutSession?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                headerSection

                // Exercise Cards
                ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                    ExerciseCard(
                        exercise: exercise,
                        index: index + 1,
                        onSwap: { swapExercise(at: index) },
                        onTap: {
                            activeExerciseIndex = index
                            showActiveWorkout = true
                        }
                    )
                }

                // Start Button
                Button {
                    startWorkout()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                        Text("Iniciar Treino")
                    }
                }
                .buttonStyle(ZenPrimaryButtonStyle())
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.zenIce.ignoresSafeArea())
        .navigationTitle("Seu Treino")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $showActiveWorkout) {
            if let index = activeExerciseIndex, let session = workoutSession {
                ExerciseDetailView(
                    exercises: exercises,
                    currentIndex: index,
                    session: session,
                    profile: profile
                )
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        GlassEffectContainer {
            HStack(spacing: 16) {
                statPill(icon: "clock.fill", value: "\(duration) min", color: .zenBlue)
                statPill(icon: "figure.strengthtraining.traditional", value: "\(exercises.count) exercícios", color: .zenMint)
            }
        }
        .padding(.top, 8)
    }

    private func statPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            Text(value)
                .font(.zenCaption())
                .foregroundColor(.zenTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .zenGlass(cornerRadius: 100)
    }

    // MARK: - Actions
    private func swapExercise(at index: Int) {
        let current = exercises[index]
        if let replacement = WorkoutEngine.swapExercise(
            current: current,
            inWorkout: exercises,
            restrictions: profile.restrictions
        ) {
            withAnimation(.spring(response: 0.4)) {
                exercises[index] = replacement
            }
        }
    }

    private func startWorkout() {
        let session = WorkoutSession(durationMinutes: duration)
        modelContext.insert(session)
        self.workoutSession = session
        activeExerciseIndex = 0
        showActiveWorkout = true
    }
}

// MARK: - Exercise Card
struct ExerciseCard: View {
    let exercise: Exercise
    let index: Int
    let onSwap: () -> Void
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Number badge
                Text("\(index)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.zenSubheadline())
                        .foregroundColor(.zenTextPrimary)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        ZenPillBadge(text: exercise.muscleGroup.rawValue, color: .zenBlue)
                        ZenPillBadge(text: exercise.equipment.rawValue, color: .zenTextSecondary)
                    }
                }

                Spacer()

                // Swap button
                Button {
                    onSwap()
                } label: {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.zenOrange)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.zenOrangeLight))
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .zenGlass(cornerRadius: 18)
        }
        .buttonStyle(.plain)
    }
}
