import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    let exercises: [Exercise]
    @State var currentIndex: Int
    @ObservedObject private var timerManager = RestTimerManager()
    let session: WorkoutSession
    let profile: UserProfile
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var currentSet = 1
    @State private var weight: Double = 10
    @State private var reps: Int = 12
    @State private var showEffortPicker = false
    @State private var showSummary = false
    @State private var completedSets: [SetRecord] = []

    private var exercise: Exercise {
        exercises[currentIndex]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Animation Hero Area
                heroSection

                // Exercise Info
                VStack(spacing: 20) {
                    // Checklist
                    checklistSection

                    // Danger Alert
                    dangerAlertSection

                    // Set Logger
                    setLoggerSection

                    // Completed Sets
                    if !completedSets.isEmpty {
                        completedSetsSection
                    }

                    // Rest Timer
                    if timerManager.isRunning {
                        restTimerSection
                    }

                    // Navigation
                    navigationButtons
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.zenIce.ignoresSafeArea())
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEffortPicker) {
            EffortPickerSheet(
                exerciseName: exercise.name,
                onSelect: { effort in
                    saveSetWithEffort(effort)
                    showEffortPicker = false
                }
            )
            .presentationDetents([.height(320)])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $showSummary) {
            WorkoutSummaryView(session: session)
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [.zenMintLight, .zenBlueLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 16) {
                ExerciseAnimationView(exerciseId: exercise.id)
                    .frame(height: 140)

                Text(exercise.instructions)
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.vertical, 24)
        }
        .frame(height: 260)
    }

    // MARK: - Checklist
    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.zenMint)
                Text("O que fazer")
                    .font(.zenSubheadline())
                    .foregroundColor(.zenTextPrimary)
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(exercise.checklist, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("✅")
                            .font(.system(size: 16))
                        Text(item)
                            .font(.zenBody())
                            .foregroundColor(.zenTextPrimary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.zenMintLight.opacity(0.3))
        .zenGlass(cornerRadius: 18)
    }

    // MARK: - Danger Alert
    private var dangerAlertSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("🚨")
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 4) {
                Text("Atenção!")
                    .font(.zenSubheadline())
                    .foregroundColor(.zenOrange)
                Text(exercise.dangerAlert)
                    .font(.zenBody())
                    .foregroundColor(.zenTextPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.zenOrangeLight.opacity(0.3))
        .zenGlass(cornerRadius: 18)
    }

    // MARK: - Set Logger
    private var setLoggerSection: some View {
        VStack(spacing: 16) {
            Text("Série \(currentSet) de \(exercise.sets)")
                .font(.zenSubheadline())
                .foregroundColor(.zenTextPrimary)

            HStack(spacing: 32) {
                // Weight
                VStack(spacing: 8) {
                    Text("Peso (kg)")
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)

                    HStack(spacing: 16) {
                        ZenStepperButton(symbol: "minus") {
                            if weight > 0 { weight -= 2.5 }
                        }

                        Text(String(format: "%.1f", weight))
                            .font(.zenLargeNumber())
                            .foregroundColor(.zenTextPrimary)
                            .frame(minWidth: 80)

                        ZenStepperButton(symbol: "plus") {
                            weight += 2.5
                        }
                    }
                }

                // Reps
                VStack(spacing: 8) {
                    Text("Repetições")
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)

                    HStack(spacing: 16) {
                        ZenStepperButton(symbol: "minus") {
                            if reps > 1 { reps -= 1 }
                        }

                        Text("\(reps)")
                            .font(.zenLargeNumber())
                            .foregroundColor(.zenTextPrimary)
                            .frame(minWidth: 50)

                        ZenStepperButton(symbol: "plus") {
                            reps += 1
                        }
                    }
                }
            }

            Button {
                completeSet()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                    Text("Concluir Série")
                }
            }
            .buttonStyle(ZenPrimaryButtonStyle())
        }
        .zenCard()
    }

    // MARK: - Completed Sets
    private var completedSetsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Séries concluídas")
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)

            ForEach(completedSets.indices, id: \.self) { i in
                HStack {
                    Text("Série \(i + 1)")
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)
                    Spacer()
                    Text("\(String(format: "%.1f", completedSets[i].weight)) kg × \(completedSets[i].reps)")
                        .font(.zenSubheadline())
                        .foregroundColor(.zenTextPrimary)
                    if let effort = completedSets[i].effort {
                        Text(effort.emoji)
                            .font(.system(size: 18))
                    }
                }
            }
        }
        .padding(16)
        .zenGlass(cornerRadius: 14)
    }

    // MARK: - Rest Timer
    private var restTimerSection: some View {
        VStack(spacing: 8) {
            Text("Descanso")
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)

            Text("\(timerManager.remaining)s")
                .font(.zenLargeNumber())
                .foregroundColor(.zenBlue)

            ProgressView(value: Double(exercise.restSeconds - timerManager.remaining), total: Double(exercise.restSeconds))
                .tint(.zenBlue)

            Button("Pular") {
                timerManager.stop()
            }
            .font(.zenCaption())
            .foregroundColor(.zenTextSecondary)
        }
        .zenCard()
    }

    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack(spacing: 12) {
            if currentIndex > 0 {
                Button {
                    moveToExercise(currentIndex - 1)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Anterior")
                    }
                }
                .buttonStyle(ZenSecondaryButtonStyle())
            }

            if currentIndex < exercises.count - 1 {
                Button {
                    moveToExercise(currentIndex + 1)
                } label: {
                    HStack(spacing: 6) {
                        Text("Próximo")
                        Image(systemName: "chevron.right")
                    }
                }
                .buttonStyle(ZenPrimaryButtonStyle(color: .zenBlue))
            } else {
                Button {
                    finishWorkout()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "flag.checkered")
                        Text("Finalizar Treino")
                    }
                }
                .buttonStyle(ZenPrimaryButtonStyle())
            }
        }
    }

    // MARK: - Actions
    private func completeSet() {
        showEffortPicker = true
    }

    private func saveSetWithEffort(_ effort: EffortFeedback) {
        let record = SetRecord(weight: weight, reps: reps, effort: effort)
        completedSets.append(record)

        if currentSet < exercise.sets {
            currentSet += 1
            timerManager.start(seconds: exercise.restSeconds)
        }
    }

    private func moveToExercise(_ newIndex: Int) {
        saveCurrentExerciseLog()
        currentIndex = newIndex
        currentSet = 1
        completedSets.removeAll()
        timerManager.stop()
    }

    private func saveCurrentExerciseLog() {
        guard !completedSets.isEmpty else { return }
        let avgWeight = completedSets.reduce(0.0) { $0 + $1.weight } / Double(completedSets.count)
        let avgReps = completedSets.reduce(0) { $0 + $1.reps } / completedSets.count
        let lastEffort = completedSets.last?.effort

        let log = ExerciseLog(
            exerciseId: exercise.id,
            exerciseName: exercise.name,
            muscleGroup: exercise.muscleGroup,
            sets: completedSets.count,
            reps: avgReps,
            weight: avgWeight
        )
        log.effort = lastEffort
        log.session = session
        session.exerciseLogs.append(log)
    }

    private func finishWorkout() {
        saveCurrentExerciseLog()
        showSummary = true
    }
}

// MARK: - Set Record (Temporary)
struct SetRecord {
    let weight: Double
    let reps: Int
    let effort: EffortFeedback?
}

// MARK: - Rest Timer Manager
class RestTimerManager: ObservableObject {
    @Published var remaining: Int = 0
    @Published var isRunning = false
    private var timer: Timer?

    func start(seconds: Int) {
        stop()
        remaining = seconds
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remaining > 0 {
                self.remaining -= 1
            } else {
                self.stop()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}

// MARK: - Effort Picker Sheet
struct EffortPickerSheet: View {
    let exerciseName: String
    let onSelect: (EffortFeedback) -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Como foi o peso?")
                    .font(.zenHeadline())
                    .foregroundColor(.zenTextPrimary)
                Text(exerciseName)
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
            }

            HStack(spacing: 16) {
                ForEach(EffortFeedback.allCases, id: \.rawValue) { effort in
                    Button {
                        onSelect(effort)
                    } label: {
                        VStack(spacing: 10) {
                            Text(effort.emoji)
                                .font(.system(size: 44))

                            Text(effort.label)
                                .font(.zenCaption())
                                .foregroundColor(.zenTextPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .zenGlass(cornerRadius: 18)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
    }
}
