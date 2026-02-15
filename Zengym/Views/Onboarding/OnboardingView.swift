import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentPage = 0
    @State private var selectedRestrictions: Set<BodyArea> = []
    @State private var userName: String = ""
    @State private var animateIn = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.zenIce, Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            TabView(selection: $currentPage) {
                // Page 1: Welcome
                welcomePage
                    .tag(0)

                // Page 2: Name
                namePage
                    .tag(1)

                // Page 3: Pain Map
                painMapPage
                    .tag(2)

                // Page 4: Confirmation
                confirmationPage
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.4), value: currentPage)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }

    // MARK: - Welcome Page
    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .scaleEffect(animateIn ? 1.0 : 0.5)
                .opacity(animateIn ? 1.0 : 0)

            VStack(spacing: 12) {
                Text("Zengym")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundColor(.zenTextPrimary)

                Text("Seu fisioterapeuta de bolso")
                    .font(.zenHeadline())
                    .foregroundColor(.zenTextSecondary)
            }
            .opacity(animateIn ? 1.0 : 0)

            VStack(spacing: 8) {
                featureRow(icon: "shield.checkmark.fill", text: "Exercícios seguros e guiados", color: .zenMint)
                featureRow(icon: "figure.walk", text: "Perfeito para iniciantes", color: .zenBlue)
                featureRow(icon: "heart.fill", text: "Cuida da sua saúde", color: .zenOrange)
            }
            .padding(.top, 16)
            .opacity(animateIn ? 1.0 : 0)

            Spacer()

            Button("Começar") {
                withAnimation { currentPage = 1 }
            }
            .buttonStyle(ZenPrimaryButtonStyle())
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Name Page
    private var namePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.zenBlue)

            Text("Como podemos te chamar?")
                .font(.zenTitle())
                .foregroundColor(.zenTextPrimary)
                .multilineTextAlignment(.center)

            TextField("Seu nome", text: $userName)
                .font(.zenHeadline())
                .multilineTextAlignment(.center)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.zenIce)
                )
                .padding(.horizontal, 40)

            Spacer()

            Button("Próximo") {
                withAnimation { currentPage = 2 }
            }
            .buttonStyle(ZenPrimaryButtonStyle())
            .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(userName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Pain Map Page
    private var painMapPage: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "stethoscope")
                    .font(.system(size: 44))
                    .foregroundColor(.zenMint)

                Text("Raio-X Seguro")
                    .font(.zenTitle())
                    .foregroundColor(.zenTextPrimary)

                Text("Você tem alguma dor crônica, sensibilidade\nou restrição de mobilidade?")
                    .font(.zenBody())
                    .foregroundColor(.zenTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)

            VStack(spacing: 12) {
                ForEach(BodyArea.allCases) { area in
                    PainAreaButton(
                        area: area,
                        isSelected: selectedRestrictions.contains(area)
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            if selectedRestrictions.contains(area) {
                                selectedRestrictions.remove(area)
                            } else {
                                selectedRestrictions.insert(area)
                            }
                        }
                    }
                }

                // "None" option
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedRestrictions.removeAll()
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: selectedRestrictions.isEmpty ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(selectedRestrictions.isEmpty ? .zenMint : .zenTextTertiary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Nenhuma restrição")
                                .font(.zenSubheadline())
                                .foregroundColor(.zenTextPrimary)
                            Text("Estou saudável e pronto para treinar!")
                                .font(.zenCaption())
                                .foregroundColor(.zenTextSecondary)
                        }

                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(selectedRestrictions.isEmpty ? Color.zenMintLight : Color.zenIce)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(selectedRestrictions.isEmpty ? Color.zenMint : Color.clear, lineWidth: 2)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)

            Spacer()

            Button("Próximo") {
                withAnimation { currentPage = 3 }
            }
            .buttonStyle(ZenPrimaryButtonStyle())
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Confirmation Page
    private var confirmationPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 70))
                .foregroundStyle(
                    LinearGradient(colors: [.zenMint, .zenBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )

            Text("Tudo pronto, \(userName.isEmpty ? "amigo" : userName)!")
                .font(.zenTitle())
                .foregroundColor(.zenTextPrimary)
                .multilineTextAlignment(.center)

            if !selectedRestrictions.isEmpty {
                VStack(spacing: 8) {
                    Text("Vamos evitar exercícios que impactem:")
                        .font(.zenBody())
                        .foregroundColor(.zenTextSecondary)

                    HStack(spacing: 8) {
                        ForEach(Array(selectedRestrictions)) { area in
                            ZenPillBadge(text: area.rawValue, color: .zenOrange)
                        }
                    }
                }
                .padding()
                .zenCard()
                .padding(.horizontal, 24)
            } else {
                Text("Sem restrições! Você tem acesso a\ntodos os exercícios.")
                    .font(.zenBody())
                    .foregroundColor(.zenTextSecondary)
                    .multilineTextAlignment(.center)
            }

            Text("Seus treinos serão personalizados\npara manter você seguro. 💚")
                .font(.zenBody())
                .foregroundColor(.zenTextSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button("Vamos treinar!") {
                completeOnboarding()
            }
            .buttonStyle(ZenPrimaryButtonStyle())
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Helpers
    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(Circle().fill(color.opacity(0.12)))

            Text(text)
                .font(.zenBody())
                .foregroundColor(.zenTextPrimary)

            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private func completeOnboarding() {
        let profile = UserProfile(
            name: userName.trimmingCharacters(in: .whitespaces),
            restrictions: Array(selectedRestrictions),
            onboardingComplete: true
        )
        modelContext.insert(profile)
    }
}

// MARK: - Pain Area Button Component
struct PainAreaButton: View {
    let area: BodyArea
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .zenOrange : .zenTextTertiary)

                Image(systemName: area.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .zenOrange : .zenTextSecondary)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(area.rawValue)
                        .font(.zenSubheadline())
                        .foregroundColor(.zenTextPrimary)
                    Text(area.description)
                        .font(.zenCaption())
                        .foregroundColor(.zenTextSecondary)
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.zenOrangeLight : Color.zenIce)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isSelected ? Color.zenOrange : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
