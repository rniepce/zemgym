import SwiftUI

// MARK: - Exercise Animation Router
struct ExerciseAnimationView: View {
    let exerciseId: String
    @State private var animate = false

    var body: some View {
        animationForExercise
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
    }

    @ViewBuilder
    private var animationForExercise: some View {
        switch movementPattern {
        case .legPress:
            LegPressAnimation(animate: animate)
        case .legExtension:
            LegExtensionAnimation(animate: animate)
        case .legCurl:
            LegCurlAnimation(animate: animate)
        case .hipAbduction:
            HipAbductionAnimation(animate: animate)
        case .calfRaise:
            CalfRaiseAnimation(animate: animate)
        case .chestPress:
            ChestPressAnimation(animate: animate)
        case .chestFly:
            ChestFlyAnimation(animate: animate)
        case .pulldown:
            PulldownAnimation(animate: animate)
        case .row:
            RowAnimation(animate: animate)
        case .shoulderPress:
            ShoulderPressAnimation(animate: animate)
        case .lateralRaise:
            LateralRaiseAnimation(animate: animate)
        case .bicepCurl:
            BicepCurlAnimation(animate: animate)
        case .tricepPushdown:
            TricepPushdownAnimation(animate: animate)
        case .abdominal:
            AbdominalAnimation(animate: animate)
        case .plank:
            PlankAnimation(animate: animate)
        case .gluteKickback:
            GluteKickbackAnimation(animate: animate)
        case .backExtension:
            BackExtensionAnimation(animate: animate)
        case .facePull:
            FacePullAnimation(animate: animate)
        }
    }

    private var movementPattern: MovementPattern {
        switch exerciseId {
        case "leg_press", "hack_squat":
            return .legPress
        case "cadeira_extensora":
            return .legExtension
        case "mesa_flexora", "leg_curl_sentado":
            return .legCurl
        case "cadeira_adutora", "cadeira_abdutora":
            return .hipAbduction
        case "panturrilha_maquina":
            return .calfRaise
        case "supino_maquina", "supino_inclinado_smith":
            return .chestPress
        case "peck_deck", "crucifixo_polia":
            return .chestFly
        case "pulldown":
            return .pulldown
        case "remada_maquina", "remada_baixa_polia":
            return .row
        case "desenvolvimento_maquina":
            return .shoulderPress
        case "elevacao_lateral_polia", "elevacao_frontal_polia":
            return .lateralRaise
        case "rosca_scott_maquina", "rosca_polia", "rosca_martelo_polia":
            return .bicepCurl
        case "triceps_polia", "triceps_frances_polia":
            return .tricepPushdown
        case "abdominal_maquina", "abdominal_polia_alta":
            return .abdominal
        case "prancha":
            return .plank
        case "gluteo_maquina":
            return .gluteKickback
        case "fly_invertido_maquina":
            return .row
        case "extensao_lombar_banco":
            return .backExtension
        case "face_pull_polia":
            return .facePull
        default:
            return .chestPress
        }
    }
}

enum MovementPattern {
    case legPress, legExtension, legCurl, hipAbduction, calfRaise
    case chestPress, chestFly
    case pulldown, row
    case shoulderPress, lateralRaise
    case bicepCurl, tricepPushdown
    case abdominal, plank
    case gluteKickback, backExtension, facePull
}

// MARK: - Stick Figure Base
struct StickFigure {
    static let headRadius: CGFloat = 14
    static let bodyColor = Color.zenMint
    static let machineColor = Color.zenBlue.opacity(0.3)
    static let weightColor = Color.zenBlue
    static let lineWidth: CGFloat = 4
}

// MARK: - 1. Leg Press
struct LegPressAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Machine seat (angled)
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 80, height: 30)
                .rotationEffect(.degrees(-30))
                .offset(x: -30, y: 10)

            // Platform
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.weightColor.opacity(0.4))
                .frame(width: 12, height: 60)
                .offset(x: animate ? 50 : 35, y: animate ? -15 : 5)

            // Body
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 28, height: 28)
                .offset(x: -50, y: -15)

            // Torso
            LineShape(from: CGPoint(x: -50, y: 0), to: CGPoint(x: -20, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper leg
            LineShape(
                from: CGPoint(x: -20, y: 20),
                to: CGPoint(x: animate ? 30 : 10, y: animate ? -5 : 15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Lower leg
            LineShape(
                from: CGPoint(x: animate ? 30 : 10, y: animate ? -5 : 15),
                to: CGPoint(x: animate ? 45 : 30, y: animate ? -15 : 0)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Foot on platform
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 10)
                .offset(x: animate ? 45 : 30, y: animate ? -15 : 0)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 2. Leg Extension
struct LegExtensionAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Seat
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 70, height: 25)
                .offset(y: 15)

            // Back support
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 20, height: 55)
                .offset(x: -35, y: -5)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 28)
                .offset(x: -35, y: -42)

            // Torso
            LineShape(from: CGPoint(x: -35, y: -25), to: CGPoint(x: -20, y: 15))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper leg (on seat)
            LineShape(from: CGPoint(x: -20, y: 15), to: CGPoint(x: 20, y: 15))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Lower leg (animating)
            LineShape(
                from: CGPoint(x: 20, y: 15),
                to: CGPoint(x: animate ? 55 : 25, y: animate ? 15 : 50)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight pad
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor.opacity(0.5))
                .frame(width: 20, height: 8)
                .offset(x: animate ? 50 : 22, y: animate ? 20 : 50)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 3. Leg Curl
struct LegCurlAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Bench
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 100, height: 20)
                .offset(y: 10)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 24)
                .offset(x: -45, y: -8)

            // Torso (lying)
            LineShape(from: CGPoint(x: -35, y: 0), to: CGPoint(x: 10, y: 0))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper leg
            LineShape(from: CGPoint(x: 10, y: 0), to: CGPoint(x: 40, y: 0))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Lower leg (curling)
            LineShape(
                from: CGPoint(x: 40, y: 0),
                to: CGPoint(x: animate ? 30 : 55, y: animate ? -30 : 0)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight pad
            Circle()
                .fill(StickFigure.weightColor.opacity(0.5))
                .frame(width: 12)
                .offset(x: animate ? 30 : 55, y: animate ? -30 : 0)
        }
        .frame(width: 180, height: 100)
    }
}

// MARK: - 4. Hip Abduction/Adduction
struct HipAbductionAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Seat
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 50, height: 20)
                .offset(y: 5)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -38)

            // Torso
            LineShape(from: CGPoint(x: 0, y: -22), to: CGPoint(x: 0, y: 5))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Left leg
            LineShape(
                from: CGPoint(x: 0, y: 5),
                to: CGPoint(x: animate ? -35 : -15, y: 45)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Right leg
            LineShape(
                from: CGPoint(x: 0, y: 5),
                to: CGPoint(x: animate ? 35 : 15, y: 45)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Pads
            Circle()
                .fill(StickFigure.weightColor.opacity(0.4))
                .frame(width: 10)
                .offset(x: animate ? -35 : -15, y: 45)

            Circle()
                .fill(StickFigure.weightColor.opacity(0.4))
                .frame(width: 10)
                .offset(x: animate ? 35 : 15, y: 45)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 5. Calf Raise
struct CalfRaiseAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Platform
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 40, height: 10)
                .offset(y: 48)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: animate ? -50 : -40)

            // Torso
            LineShape(
                from: CGPoint(x: 0, y: animate ? -34 : -24),
                to: CGPoint(x: 0, y: animate ? 8 : 18)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Legs
            LineShape(
                from: CGPoint(x: 0, y: animate ? 8 : 18),
                to: CGPoint(x: 0, y: 42)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Feet (tippy toes)
            Capsule()
                .fill(StickFigure.bodyColor)
                .frame(width: 20, height: 8)
                .offset(y: 46)

            // Shoulder pads
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor.opacity(0.4))
                .frame(width: 40, height: 8)
                .offset(y: animate ? -36 : -26)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 6. Chest Press
struct ChestPressAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Seat back
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 20, height: 60)
                .offset(x: -40, y: 0)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(x: -40, y: -40)

            // Torso
            LineShape(from: CGPoint(x: -40, y: -24), to: CGPoint(x: -40, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper arm
            LineShape(
                from: CGPoint(x: -35, y: -10),
                to: CGPoint(x: animate ? 10 : -15, y: -10)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Forearm
            LineShape(
                from: CGPoint(x: animate ? 10 : -15, y: -10),
                to: CGPoint(x: animate ? 40 : -5, y: animate ? -10 : -10)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight handle
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor)
                .frame(width: 8, height: 30)
                .offset(x: animate ? 40 : -5, y: -10)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 7. Chest Fly
struct ChestFlyAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Back support
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 16, height: 50)
                .offset(y: -5)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -40)

            // Left arm
            LineShape(
                from: CGPoint(x: 0, y: -12),
                to: CGPoint(x: animate ? -8 : -40, y: animate ? -12 : -20)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Right arm
            LineShape(
                from: CGPoint(x: 0, y: -12),
                to: CGPoint(x: animate ? 8 : 40, y: animate ? -12 : -20)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight pads
            Circle()
                .fill(StickFigure.weightColor.opacity(0.5))
                .frame(width: 12)
                .offset(x: animate ? -8 : -40, y: animate ? -12 : -20)

            Circle()
                .fill(StickFigure.weightColor.opacity(0.5))
                .frame(width: 12)
                .offset(x: animate ? 8 : 40, y: animate ? -12 : -20)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 8. Pulldown
struct PulldownAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Cable line (vertical)
            LineShape(from: CGPoint(x: 0, y: -55), to: CGPoint(x: 0, y: animate ? -5 : -45))
                .stroke(StickFigure.weightColor.opacity(0.3), lineWidth: 2)

            // Bar
            RoundedRectangle(cornerRadius: 2)
                .fill(StickFigure.weightColor)
                .frame(width: 60, height: 6)
                .offset(y: animate ? -5 : -45)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -30)

            // Torso
            LineShape(from: CGPoint(x: 0, y: -14), to: CGPoint(x: 0, y: 25))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Left arm
            LineShape(
                from: CGPoint(x: 0, y: -12),
                to: CGPoint(x: -30, y: animate ? -5 : -45)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Right arm
            LineShape(
                from: CGPoint(x: 0, y: -12),
                to: CGPoint(x: 30, y: animate ? -5 : -45)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Seat
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 50, height: 14)
                .offset(y: 30)
        }
        .frame(width: 180, height: 130)
    }
}

// MARK: - 9. Row
struct RowAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Chest pad
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 14, height: 40)
                .offset(x: 10, y: -5)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(x: 12, y: -35)

            // Torso
            LineShape(from: CGPoint(x: 12, y: -20), to: CGPoint(x: 12, y: 25))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Arms pulling
            LineShape(
                from: CGPoint(x: 10, y: -8),
                to: CGPoint(x: animate ? -10 : -40, y: -8)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor)
                .frame(width: 6, height: 20)
                .offset(x: animate ? -10 : -40, y: -8)

            // Cable
            LineShape(
                from: CGPoint(x: animate ? -10 : -40, y: -8),
                to: CGPoint(x: -55, y: -8)
            )
            .stroke(StickFigure.weightColor.opacity(0.3), lineWidth: 2)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 10. Shoulder Press
struct ShoulderPressAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Seat
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 50, height: 16)
                .offset(y: 30)

            // Back rest
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 16, height: 50)
                .offset(y: 0)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -35)

            // Left arm pushing up
            LineShape(
                from: CGPoint(x: -5, y: -15),
                to: CGPoint(x: -20, y: animate ? -50 : -15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Right arm pushing up
            LineShape(
                from: CGPoint(x: 5, y: -15),
                to: CGPoint(x: 20, y: animate ? -50 : -15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight handles
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor)
                .frame(width: 8, height: 14)
                .offset(x: -20, y: animate ? -50 : -15)

            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor)
                .frame(width: 8, height: 14)
                .offset(x: 20, y: animate ? -50 : -15)
        }
        .frame(width: 180, height: 130)
    }
}

// MARK: - 11. Lateral Raise
struct LateralRaiseAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -40)

            // Torso
            LineShape(from: CGPoint(x: 0, y: -24), to: CGPoint(x: 0, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Legs
            LineShape(from: CGPoint(x: 0, y: 20), to: CGPoint(x: -10, y: 50))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(from: CGPoint(x: 0, y: 20), to: CGPoint(x: 10, y: 50))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Left arm raising
            LineShape(
                from: CGPoint(x: 0, y: -15),
                to: CGPoint(x: animate ? -45 : -10, y: animate ? -25 : 10)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Right arm raising
            LineShape(
                from: CGPoint(x: 0, y: -15),
                to: CGPoint(x: animate ? 45 : 10, y: animate ? -25 : 10)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weights
            Circle()
                .fill(StickFigure.weightColor)
                .frame(width: 10)
                .offset(x: animate ? -45 : -10, y: animate ? -25 : 10)

            Circle()
                .fill(StickFigure.weightColor)
                .frame(width: 10)
                .offset(x: animate ? 45 : 10, y: animate ? -25 : 10)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 12. Bicep Curl
struct BicepCurlAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -40)

            // Torso
            LineShape(from: CGPoint(x: 0, y: -24), to: CGPoint(x: 0, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper arm (fixed)
            LineShape(from: CGPoint(x: 0, y: -12), to: CGPoint(x: 20, y: 10))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Forearm (curling)
            LineShape(
                from: CGPoint(x: 20, y: 10),
                to: CGPoint(x: animate ? 10 : 35, y: animate ? -15 : 35)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight
            RoundedRectangle(cornerRadius: 3)
                .fill(StickFigure.weightColor)
                .frame(width: 20, height: 8)
                .offset(x: animate ? 10 : 35, y: animate ? -15 : 35)

            // Legs
            LineShape(from: CGPoint(x: 0, y: 20), to: CGPoint(x: -8, y: 50))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(from: CGPoint(x: 0, y: 20), to: CGPoint(x: 8, y: 50))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - 13. Tricep Pushdown
struct TricepPushdownAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Cable
            LineShape(from: CGPoint(x: 0, y: -55), to: CGPoint(x: 0, y: animate ? 20 : -20))
                .stroke(StickFigure.weightColor.opacity(0.3), lineWidth: 2)

            // Bar
            RoundedRectangle(cornerRadius: 2)
                .fill(StickFigure.weightColor)
                .frame(width: 30, height: 6)
                .offset(y: animate ? 20 : -20)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(y: -40)

            // Torso
            LineShape(from: CGPoint(x: 0, y: -24), to: CGPoint(x: 0, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Upper arms (fixed, close to body)
            LineShape(from: CGPoint(x: -3, y: -12), to: CGPoint(x: -5, y: 5))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(from: CGPoint(x: 3, y: -12), to: CGPoint(x: 5, y: 5))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Forearms (pushing down)
            LineShape(
                from: CGPoint(x: -5, y: 5),
                to: CGPoint(x: -10, y: animate ? 20 : -5)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(
                from: CGPoint(x: 5, y: 5),
                to: CGPoint(x: 10, y: animate ? 20 : -5)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
        }
        .frame(width: 180, height: 130)
    }
}

// MARK: - 14. Abdominal
struct AbdominalAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Bench
            RoundedRectangle(cornerRadius: 6)
                .fill(StickFigure.machineColor)
                .frame(width: 80, height: 16)
                .offset(y: 20)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 24)
                .offset(
                    x: animate ? -15 : -35,
                    y: animate ? -15 : 0
                )

            // Torso (crunching)
            LineShape(
                from: CGPoint(x: animate ? -10 : -30, y: animate ? -3 : 10),
                to: CGPoint(x: 10, y: 12)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Legs (bent)
            LineShape(from: CGPoint(x: 10, y: 12), to: CGPoint(x: 30, y: -5))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(from: CGPoint(x: 30, y: -5), to: CGPoint(x: 40, y: 12))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
        }
        .frame(width: 180, height: 100)
    }
}

// MARK: - 15. Plank
struct PlankAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Body line (slight pulse)
            LineShape(
                from: CGPoint(x: -50, y: animate ? -2 : 2),
                to: CGPoint(x: 40, y: animate ? -2 : 2)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth + 1)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 22)
                .offset(x: -55, y: animate ? -12 : -8)

            // Arms (supporting)
            LineShape(from: CGPoint(x: -35, y: 0), to: CGPoint(x: -35, y: 18))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Feet
            LineShape(from: CGPoint(x: 40, y: 0), to: CGPoint(x: 45, y: 18))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Ground line
            LineShape(from: CGPoint(x: -60, y: 20), to: CGPoint(x: 60, y: 20))
                .stroke(StickFigure.machineColor, lineWidth: 2)

            // Glow effect for core
            Capsule()
                .fill(StickFigure.bodyColor.opacity(animate ? 0.3 : 0.1))
                .frame(width: 30, height: 14)
                .offset(x: -5, y: 0)
        }
        .frame(width: 180, height: 80)
    }
}

// MARK: - 16. Glute Kickback
struct GluteKickbackAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Machine pad
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 14, height: 40)
                .offset(x: -10, y: -5)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 24)
                .offset(x: -10, y: -35)

            // Torso
            LineShape(from: CGPoint(x: -10, y: -20), to: CGPoint(x: -10, y: 15))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Standing leg
            LineShape(from: CGPoint(x: -10, y: 15), to: CGPoint(x: -10, y: 45))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Kicking leg
            LineShape(
                from: CGPoint(x: -10, y: 15),
                to: CGPoint(x: animate ? 35 : 0, y: animate ? 5 : 40)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Weight pad on leg
            Circle()
                .fill(StickFigure.weightColor.opacity(0.5))
                .frame(width: 12)
                .offset(x: animate ? 35 : 0, y: animate ? 5 : 40)
        }
        .frame(width: 180, height: 110)
    }
}

// MARK: - 17. Back Extension
struct BackExtensionAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Pad
            RoundedRectangle(cornerRadius: 4)
                .fill(StickFigure.machineColor)
                .frame(width: 14, height: 30)
                .rotationEffect(.degrees(45))
                .offset(x: 5, y: 15)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 24)
                .offset(
                    x: animate ? -30 : -40,
                    y: animate ? -25 : 10
                )

            // Torso (extending up)
            LineShape(
                from: CGPoint(x: animate ? -25 : -35, y: animate ? -12 : 15),
                to: CGPoint(x: 5, y: 15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Legs (fixed)
            LineShape(from: CGPoint(x: 5, y: 15), to: CGPoint(x: 30, y: 40))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
        }
        .frame(width: 180, height: 100)
    }
}

// MARK: - 18. Face Pull
struct FacePullAnimation: View {
    let animate: Bool

    var body: some View {
        ZStack {
            // Cable
            LineShape(
                from: CGPoint(x: -50, y: -15),
                to: CGPoint(x: animate ? -5 : -35, y: -15)
            )
            .stroke(StickFigure.weightColor.opacity(0.3), lineWidth: 2)

            // Head
            Circle()
                .fill(StickFigure.bodyColor)
                .frame(width: 26)
                .offset(x: 10, y: -35)

            // Torso
            LineShape(from: CGPoint(x: 10, y: -20), to: CGPoint(x: 10, y: 20))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Arms pulling (elbows out)
            LineShape(
                from: CGPoint(x: 10, y: -15),
                to: CGPoint(x: animate ? -5 : -25, y: animate ? -25 : -15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            LineShape(
                from: CGPoint(x: 10, y: -15),
                to: CGPoint(x: animate ? -5 : -25, y: animate ? -5 : -15)
            )
            .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)

            // Rope ends
            Circle()
                .fill(StickFigure.weightColor)
                .frame(width: 8)
                .offset(x: animate ? -5 : -25, y: animate ? -25 : -15)
            Circle()
                .fill(StickFigure.weightColor)
                .frame(width: 8)
                .offset(x: animate ? -5 : -25, y: animate ? -5 : -15)

            // Legs
            LineShape(from: CGPoint(x: 10, y: 20), to: CGPoint(x: 3, y: 48))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
            LineShape(from: CGPoint(x: 10, y: 20), to: CGPoint(x: 17, y: 48))
                .stroke(StickFigure.bodyColor, lineWidth: StickFigure.lineWidth)
        }
        .frame(width: 180, height: 120)
    }
}

// MARK: - Line Shape Helper
struct LineShape: Shape {
    var from: CGPoint
    var to: CGPoint

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get { .init(.init(from.x, from.y), .init(to.x, to.y)) }
        set {
            from = CGPoint(x: newValue.first.first, y: newValue.first.second)
            to = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x + from.x, y: center.y + from.y))
        path.addLine(to: CGPoint(x: center.x + to.x, y: center.y + to.y))
        return path
    }
}
