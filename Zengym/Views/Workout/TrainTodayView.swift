import SwiftUI

struct TrainTodayView: View {
    let profile: UserProfile
    @State private var healthManager = HealthManager.shared
    @State private var selectedDuration: Int = 45
    @State private var selectedSplit: WorkoutSplit = .fullBody
    @State private var generatedWorkout: [Exercise] = []
    @State private var showWorkoutList = false
    @State private var animatePulse = false

    private let durations = [30, 45, 60]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Greeting
                    greetingSection

                    // Big "Treinar Hoje" Button
                    trainButton

                    // Duration Picker
                    durationPicker

                    // Split Picker
                    splitPicker

                    // Health Stats (if connected)
                    if healthManager.isAuthorized {
                        healthStatsSection
                    }

                    // Quick Stats
                    quickInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .background(Color.zenIce.ignoresSafeArea())
            .navigationTitle("")
            .navigationDestination(isPresented: $showWorkoutList) {
                WorkoutListView(
                    exercises: generatedWorkout,
                    duration: selectedDuration,
                    profile: profile
                )
            }
        }
    }

    // MARK: - Greeting
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(greetingText)
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)

            Text("Olá, \(profile.name.isEmpty ? "amigo" : profile.name)! 👋")
                .font(.zenTitle())
                .foregroundColor(.zenTextPrimary)

            if !profile.restrictions.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "shield.checkmark.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.zenMint)
                    Text("Protegendo: \(profile.restrictions.map { $0.rawValue }.joined(separator: ", "))")
                        .font(.zenCaption())
                        .foregroundColor(.zenMint)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Train Button
    private var trainButton: some View {
        Button {
            generateAndShow()
        } label: {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.zenMint, .zenBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: .zenMint.opacity(0.35), radius: 20, y: 8)
                        .scaleEffect(animatePulse ? 1.05 : 1.0)

                    Image(systemName: "play.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }

                Text("Treinar Hoje")
                    .font(.zenHeadline())
                    .foregroundColor(.zenTextPrimary)

                Text("\(selectedDuration) min • \(selectedSplit.rawValue)")
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .zenGlass(cornerRadius: 24)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animatePulse = true
            }
        }
    }

    // MARK: - Duration Picker
    private var durationPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quanto tempo você tem?")
                .font(.zenSubheadline())
                .foregroundColor(.zenTextPrimary)

            GlassEffectContainer {
                HStack(spacing: 12) {
                    ForEach(durations, id: \.self) { duration in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDuration = duration
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text("\(duration)")
                                    .font(.zenLargeNumber())
                                    .foregroundColor(selectedDuration == duration ? .zenMint : .zenTextPrimary)
                                Text("min")
                                    .font(.zenCaption())
                                    .foregroundColor(selectedDuration == duration ? .zenMint.opacity(0.8) : .zenTextSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .glassEffect(
                                selectedDuration == duration ? .regular.interactive(true) : .regular,
                                in: .rect(cornerRadius: 20)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Split Picker
    private var splitPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Foco do treino")
                .font(.zenSubheadline())
                .foregroundColor(.zenTextPrimary)

            GlassEffectContainer {
                HStack(spacing: 10) {
                    ForEach(WorkoutSplit.allCases, id: \.rawValue) { split in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSplit = split
                            }
                        } label: {
                            Text(split.rawValue)
                                .font(.zenCaption())
                                .foregroundColor(selectedSplit == split ? .zenMint : .zenTextPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .glassEffect(
                                    selectedSplit == split ? .regular.interactive(true) : .regular,
                                    in: .capsule
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Quick Info
    private var quickInfoSection: some View {
        GlassEffectContainer {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    infoCard(icon: "figure.walk", title: "Seguro", subtitle: "Máquinas guiadas", color: .zenMint)
                    infoCard(icon: "brain.head.profile", title: "Simples", subtitle: "Sem complicação", color: .zenBlue)
                }
                HStack(spacing: 12) {
                    infoCard(icon: "arrow.triangle.swap", title: "Flexível", subtitle: "Troque exercícios", color: .zenOrange)
                    infoCard(icon: "heart.text.square", title: "Saúde", subtitle: "Integra com Apple", color: .zenRed)
                }
            }
        }
    }

    private func infoCard(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(Circle().fill(color.opacity(0.12)))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.zenCaption())
                    .foregroundColor(.zenTextPrimary)
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundColor(.zenTextTertiary)
            }

            Spacer()
        }
        .padding(14)
        .zenGlass(cornerRadius: 16)
    }

    // MARK: - Health Stats
    private var healthStatsSection: some View {
        GlassEffectContainer {
            HStack(spacing: 12) {
                healthCard(
                    icon: "flame.fill",
                    value: "\(Int(healthManager.activeEnergy))",
                    unit: "kcal",
                    color: .zenOrange
                )
                
                healthCard(
                    icon: "figure.walk",
                    value: "\(Int(healthManager.stepCount))",
                    unit: "passos",
                    color: .zenBlue
                )
            }
        }
    }
    
    private func healthCard(icon: String, value: String, unit: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(Circle().fill(color.opacity(0.12)))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.zenHeadline())
                    .foregroundColor(.zenTextPrimary)
                Text(unit)
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
            }
            Spacer()
        }
        .padding(14)
        .zenGlass(cornerRadius: 16)
    }

    // MARK: - Actions
    private func generateAndShow() {
        generatedWorkout = WorkoutEngine.generateWorkout(
            duration: selectedDuration,
            restrictions: profile.restrictions,
            split: selectedSplit
        )
        showWorkoutList = true
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia ☀️"
        case 12..<18: return "Boa tarde 🌤️"
        default: return "Boa noite 🌙"
        }
    }
}
