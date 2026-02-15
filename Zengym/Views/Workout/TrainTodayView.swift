import SwiftUI

struct TrainTodayView: View {
    let profile: UserProfile
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
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.zenCard)
                    .shadow(color: .black.opacity(0.05), radius: 16, y: 6)
            )
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
                                .foregroundColor(selectedDuration == duration ? .white : .zenTextPrimary)
                            Text("min")
                                .font(.zenCaption())
                                .foregroundColor(selectedDuration == duration ? .white.opacity(0.8) : .zenTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedDuration == duration ?
                                      LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                      LinearGradient(colors: [Color.zenCard, Color.zenCard], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: selectedDuration == duration ? .zenMint.opacity(0.3) : .black.opacity(0.04), radius: 8, y: 4)
                        )
                    }
                    .buttonStyle(.plain)
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

            HStack(spacing: 10) {
                ForEach(WorkoutSplit.allCases, id: \.rawValue) { split in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedSplit = split
                        }
                    } label: {
                        Text(split.rawValue)
                            .font(.zenCaption())
                            .foregroundColor(selectedSplit == split ? .white : .zenTextPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(selectedSplit == split ? Color.zenMint : Color.zenCard)
                                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Quick Info
    private var quickInfoSection: some View {
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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.zenCard)
                .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        )
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
