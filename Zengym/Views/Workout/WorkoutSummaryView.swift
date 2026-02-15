import SwiftUI

struct WorkoutSummaryView: View {
    let session: WorkoutSession
    @Environment(\.dismiss) private var dismiss
    @State private var animateConfetti = false
    @State private var showHealthKitSaved = false

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer(minLength: 20)

                // Celebration
                celebrationSection

                // Stats Grid
                statsSection

                // Exercise Breakdown
                exerciseBreakdown

                // Health Integration
                healthSection

                // Done Button
                Button {
                    HealthKitManager.shared.saveWorkout(
                        durationMinutes: session.durationMinutes,
                        calories: estimatedCalories
                    )
                    // Pop to root
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Concluir")
                    }
                }
                .buttonStyle(ZenPrimaryButtonStyle())
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.zenIce.ignoresSafeArea())
        .navigationTitle("Resumo")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                animateConfetti = true
            }
        }
    }

    // MARK: - Celebration
    private var celebrationSection: some View {
        VStack(spacing: 16) {
            Text("🎉")
                .font(.system(size: 64))
                .scaleEffect(animateConfetti ? 1.0 : 0.3)
                .opacity(animateConfetti ? 1.0 : 0)

            Text("Ótimo trabalho!")
                .font(.zenTitle())
                .foregroundColor(.zenTextPrimary)

            Text("Lembre-se de focar na respiração\ne na postura no dia a dia. 💚")
                .font(.zenBody())
                .foregroundColor(.zenTextSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 12) {
            statCard(value: "\(session.durationMinutes)", unit: "min", label: "Duração", icon: "clock.fill", color: .zenBlue)
            statCard(value: "\(session.exerciseCount)", unit: "", label: "Exercícios", icon: "figure.strengthtraining.traditional", color: .zenMint)
            statCard(value: "\(Int(session.totalVolume))", unit: "kg", label: "Volume", icon: "scalemass.fill", color: .zenOrange)
        }
    }

    private func statCard(value: String, unit: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.zenTextPrimary)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)
                }
            }

            Text(label)
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.zenCard)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
        )
    }

    // MARK: - Exercise Breakdown
    private var exerciseBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detalhes")
                .font(.zenSubheadline())
                .foregroundColor(.zenTextPrimary)

            ForEach(session.exerciseLogs, id: \.exerciseId) { log in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(log.exerciseName)
                            .font(.zenBody())
                            .foregroundColor(.zenTextPrimary)
                        Text("\(log.sets)×\(log.reps) • \(String(format: "%.1f", log.weight)) kg")
                            .font(.zenCaption())
                            .foregroundColor(.zenTextSecondary)
                    }
                    Spacer()
                    if let effort = log.effort {
                        Text(effort.emoji)
                            .font(.system(size: 24))
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.zenCard)
                )
            }
        }
    }

    // MARK: - Health Section
    private var healthSection: some View {
        HStack(spacing: 14) {
            Image(systemName: "heart.fill")
                .font(.system(size: 22))
                .foregroundColor(.red)

            VStack(alignment: .leading, spacing: 2) {
                Text("Apple Saúde")
                    .font(.zenSubheadline())
                    .foregroundColor(.zenTextPrimary)
                Text("≈ \(estimatedCalories) kcal serão salvas automaticamente")
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.zenMint)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.zenCard)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
    }

    private var estimatedCalories: Int {
        // Rough estimate: ~5 kcal/min for weight training
        session.durationMinutes * 5
    }
}
