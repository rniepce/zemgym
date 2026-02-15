import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @State private var selectedSession: WorkoutSession?

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    emptyState
                } else {
                    sessionList
                }
            }
            .background(Color.zenIce.ignoresSafeArea())
            .navigationTitle("Histórico")
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.zenTextTertiary)

            VStack(spacing: 8) {
                Text("Nenhum treino ainda")
                    .font(.zenHeadline())
                    .foregroundColor(.zenTextPrimary)

                Text("Seus treinos aparecerão aqui\nassim que você começar! 💪")
                    .font(.zenBody())
                    .foregroundColor(.zenTextSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }

    // MARK: - Session List
    private var sessionList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Weekly Summary
                weeklySummary

                ForEach(sessions) { session in
                    SessionCard(session: session)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }

    // MARK: - Weekly Summary
    private var weeklySummary: some View {
        let thisWeek = sessionsThisWeek
        return HStack(spacing: 12) {
            summaryPill(value: "\(thisWeek.count)", label: "treinos", icon: "flame.fill", color: .zenOrange)
            summaryPill(value: "\(totalMinutesThisWeek)", label: "min", icon: "clock.fill", color: .zenBlue)
            summaryPill(value: "\(Int(totalVolumeThisWeek))", label: "kg", icon: "scalemass.fill", color: .zenMint)
        }
        .padding(.bottom, 8)
    }

    private func summaryPill(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.zenTextPrimary)

            Text(label)
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.zenCard)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
        )
    }

    // MARK: - Computed Properties
    private var sessionsThisWeek: [WorkoutSession] {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())?.start ?? Date()
        return sessions.filter { $0.date >= startOfWeek }
    }

    private var totalMinutesThisWeek: Int {
        sessionsThisWeek.reduce(0) { $0 + $1.durationMinutes }
    }

    private var totalVolumeThisWeek: Double {
        sessionsThisWeek.reduce(0) { $0 + $1.totalVolume }
    }
}

// MARK: - Session Card
struct SessionCard: View {
    let session: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.formattedDate)
                        .font(.zenSubheadline())
                        .foregroundColor(.zenTextPrimary)

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text("\(session.durationMinutes) min")
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 12))
                            Text("\(session.exerciseCount) exercícios")
                        }
                    }
                    .font(.zenCaption())
                    .foregroundColor(.zenTextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(session.totalVolume))")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.zenMint)
                    Text("kg total")
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)
                }
            }

            // Exercise pills
            if !session.exerciseLogs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(session.exerciseLogs, id: \.exerciseId) { log in
                            ZenPillBadge(
                                text: log.exerciseName,
                                color: .zenBlue
                            )
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.zenCard)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
        )
    }
}
