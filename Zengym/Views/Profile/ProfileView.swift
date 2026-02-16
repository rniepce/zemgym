import SwiftUI
import SwiftData

struct ProfileView: View {
    @Bindable var profile: UserProfile
    @Environment(\.modelContext) private var modelContext
    @State private var showResetConfirmation = false
    @State private var editingRestrictions = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Avatar & Name
                    profileHeader

                    // Restrictions
                    restrictionsSection

                    // Stats
                    statsSection

                    // Health
                    healthKitSection

                    // Settings
                    settingsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .background(Color.zenIce.ignoresSafeArea())
            .navigationTitle("Perfil")
            .alert("Resetar Onboarding?", isPresented: $showResetConfirmation) {
                Button("Cancelar", role: .cancel) {}
                Button("Resetar", role: .destructive) {
                    resetOnboarding()
                }
            } message: {
                Text("Isso irá apagar seu perfil e reiniciar o app como se fosse a primeira vez.")
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: .zenMint.opacity(0.3), radius: 12, y: 4)

                Text(profile.name.prefix(1).uppercased())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            Text(profile.name.isEmpty ? "Usuário" : profile.name)
                .font(.zenHeadline())
                .foregroundColor(.zenTextPrimary)

            Text("Membro desde \(memberSinceDate)")
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Restrictions
    private var restrictionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.checkmark.fill")
                    .foregroundColor(.zenMint)
                Text("Restrições de Saúde")
                    .font(.zenSubheadline())
                    .foregroundColor(.zenTextPrimary)
                Spacer()
                Button("Editar") {
                    editingRestrictions.toggle()
                }
                .font(.zenCaption())
                .foregroundColor(.zenBlue)
            }

            if profile.restrictions.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.zenMint)
                    Text("Sem restrições — todos os exercícios disponíveis")
                        .font(.zenBody())
                        .foregroundColor(.zenTextSecondary)
                }
            } else {
                HStack(spacing: 8) {
                    ForEach(profile.restrictions) { area in
                        ZenPillBadge(text: area.rawValue, color: .zenOrange)
                    }
                }
            }

            if editingRestrictions {
                GlassEffectContainer {
                    VStack(spacing: 8) {
                        ForEach(BodyArea.allCases) { area in
                            Button {
                                withAnimation {
                                    if profile.hasRestriction(area) {
                                        profile.restrictions.removeAll { $0 == area }
                                    } else {
                                        profile.restrictions.append(area)
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: profile.hasRestriction(area) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(profile.hasRestriction(area) ? .zenOrange : .zenTextTertiary)
                                    Text(area.rawValue)
                                        .font(.zenBody())
                                        .foregroundColor(.zenTextPrimary)
                                    Spacer()
                                }
                                .padding(12)
                                .glassEffect(
                                    profile.hasRestriction(area) ? .regular.interactive(true) : .regular,
                                    in: .rect(cornerRadius: 12)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .zenCard()
    }

    // MARK: - Stats
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.zenBlue)
                Text("Estatísticas")
                    .font(.zenSubheadline())
                    .foregroundColor(.zenTextPrimary)
            }

            GlassEffectContainer {
                HStack(spacing: 12) {
                    statItem(value: "\(sessions.count)", label: "Treinos", color: .zenMint)
                    statItem(value: "\(totalMinutes)", label: "Minutos", color: .zenBlue)
                    statItem(value: "\(Int(totalVolume))", label: "kg Total", color: .zenOrange)
                }
            }
        }
        .zenCard()
    }

    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.zenCaption())
                .foregroundColor(.zenTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - HealthKit
    private var healthKitSection: some View {
        Button {
            Task {
                await HealthManager.shared.requestAuthorization()
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.red)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Apple Saúde")
                        .font(.zenSubheadline())
                        .foregroundColor(.zenTextPrimary)
                    Text("Conectar para salvar treinos e calorias")
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)
                }

                Spacer()

                Image(systemName: HealthManager.shared.isAuthorized ? "checkmark.circle.fill" : "chevron.right")
                    .foregroundColor(HealthManager.shared.isAuthorized ? .zenMint : .zenTextTertiary)
            }
        }
        .buttonStyle(.plain)
        .zenCard()
    }

    // MARK: - Settings
    private var settingsSection: some View {
        VStack(spacing: 12) {
            settingsRow(icon: "arrow.counterclockwise", title: "Resetar Onboarding", color: .zenRed) {
                showResetConfirmation = true
            }
        }
    }

    private func settingsRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 32)

                Text(title)
                    .font(.zenBody())
                    .foregroundColor(.zenTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.zenTextTertiary)
            }
            .padding(16)
            .zenGlass(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed
    private var memberSinceDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: profile.createdAt)
    }

    private var totalMinutes: Int {
        sessions.reduce(0) { $0 + $1.durationMinutes }
    }

    private var totalVolume: Double {
        sessions.reduce(0) { $0 + $1.totalVolume }
    }

    private func resetOnboarding() {
        profile.onboardingComplete = false
        profile.restrictions = []
    }
}
