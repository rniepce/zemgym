import SwiftUI

// MARK: - Exercise Animation Router
struct ExerciseAnimationView: View {
    let exerciseId: String
    @State private var progress: CGFloat = 0
    private let timer = Timer.publish(every: 1.0/30.0, on: .main, in: .common).autoconnect()

    var body: some View {
        animationForExercise
            .onReceive(timer) { _ in
                progress += 0.03
            }
    }

    /// Smooth 0→1→0 oscillation
    private var t: CGFloat {
        (sin(progress * .pi) + 1) / 2
    }

    @ViewBuilder
    private var animationForExercise: some View {
        switch exerciseId {
        case "leg_press", "hack_squat":
            LegPressAnim(t: t)
        case "cadeira_extensora":
            LegExtensionAnim(t: t)
        case "mesa_flexora", "leg_curl_sentado":
            LegCurlAnim(t: t)
        case "cadeira_adutora", "cadeira_abdutora":
            HipAbductionAnim(t: t)
        case "panturrilha_maquina":
            CalfRaiseAnim(t: t)
        case "supino_maquina", "supino_inclinado_smith":
            ChestPressAnim(t: t)
        case "peck_deck", "crucifixo_polia":
            ChestFlyAnim(t: t)
        case "pulldown":
            PulldownAnim(t: t)
        case "remada_maquina", "remada_baixa_polia", "fly_invertido_maquina":
            RowAnim(t: t)
        case "desenvolvimento_maquina":
            ShoulderPressAnim(t: t)
        case "elevacao_lateral_polia", "elevacao_frontal_polia":
            LateralRaiseAnim(t: t)
        case "rosca_scott_maquina", "rosca_polia", "rosca_martelo_polia":
            BicepCurlAnim(t: t)
        case "triceps_polia", "triceps_frances_polia":
            TricepPushdownAnim(t: t)
        case "abdominal_maquina", "abdominal_polia_alta":
            AbdominalAnim(t: t)
        case "prancha":
            PlankAnim(t: t)
        case "gluteo_maquina":
            GluteKickbackAnim(t: t)
        case "extensao_lombar_banco":
            BackExtensionAnim(t: t)
        case "face_pull_polia":
            FacePullAnim(t: t)
        default:
            ChestPressAnim(t: t)
        }
    }
}

// MARK: - Lerp helper
private func mix(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}

// MARK: - Shared colors
private let bodyC = Color.zenMint
private let machC = Color.zenBlue.opacity(0.25)
private let weightC = Color.zenBlue

// MARK: - Stick line
private struct Stick: View {
    let x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat
    var color: Color = Color.zenMint
    var width: CGFloat = 4

    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: x1, y: y1))
            p.addLine(to: CGPoint(x: x2, y: y2))
        }
        .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))
    }
}

// MARK: - Dot
private struct Dot: View {
    let x: CGFloat, y: CGFloat, size: CGFloat
    var color: Color = Color.zenMint

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(x: x, y: y)
    }
}

// MARK: - Box
private struct Box: View {
    let x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat
    var color: Color = Color.zenBlue.opacity(0.25)
    var radius: CGFloat = 5

    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(color)
            .frame(width: w, height: h)
            .position(x: x, y: y)
    }
}

// MARK: - 1. Leg Press
struct LegPressAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 35, y: 65, w: 70, h: 22, color: machC)
            Dot(x: 30, y: 35, size: 24)
            Stick(x1: 30, y1: 48, x2: 55, y2: 72)
            Stick(x1: 55, y1: 72, x2: mix(80, 115, t), y2: mix(65, 42, t))
            Stick(x1: mix(80, 115, t), y1: mix(65, 42, t), x2: mix(100, 130, t), y2: mix(50, 30, t))
            Dot(x: mix(100, 130, t), y: mix(50, 30, t), size: 10)
            Box(x: mix(103, 133, t), y: mix(50, 30, t), w: 10, h: 45, color: weightC.opacity(0.4))
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 2. Leg Extension
struct LegExtensionAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 55, y: 68, w: 70, h: 18, color: machC)
            Box(x: 22, y: 50, w: 16, h: 50, color: machC)
            Dot(x: 22, y: 22, size: 24)
            Stick(x1: 22, y1: 35, x2: 35, y2: 65)
            Stick(x1: 35, y1: 65, x2: 75, y2: 65)
            Stick(x1: 75, y1: 65, x2: mix(80, 130, t), y2: mix(98, 65, t))
            Box(x: mix(82, 132, t), y: mix(100, 70, t), w: 18, h: 7, color: weightC.opacity(0.5))
        }
        .frame(width: 170, height: 120)
    }
}

// MARK: - 3. Leg Curl
struct LegCurlAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 58, w: 110, h: 14, color: machC)
            Dot(x: 25, y: 42, size: 22)
            Stick(x1: 37, y1: 48, x2: 80, y2: 48)
            Stick(x1: 80, y1: 48, x2: 110, y2: 48)
            Stick(x1: 110, y1: 48, x2: mix(135, 100, t), y2: mix(48, 18, t))
            Dot(x: mix(135, 100, t), y: mix(48, 18, t), size: 12, color: weightC.opacity(0.6))
        }
        .frame(width: 170, height: 90)
    }
}

// MARK: - 4. Hip Abduction
struct HipAbductionAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 55, w: 50, h: 16, color: machC)
            Dot(x: 85, y: 22, size: 24)
            Stick(x1: 85, y1: 35, x2: 85, y2: 55)
            Stick(x1: 85, y1: 55, x2: mix(70, 45, t), y2: 100)
            Stick(x1: 85, y1: 55, x2: mix(100, 125, t), y2: 100)
            Dot(x: mix(70, 45, t), y: 100, size: 10, color: weightC.opacity(0.5))
            Dot(x: mix(100, 125, t), y: 100, size: 10, color: weightC.opacity(0.5))
        }
        .frame(width: 170, height: 115)
    }
}

// MARK: - 5. Calf Raise
struct CalfRaiseAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 102, w: 40, h: 8, color: machC)
            Dot(x: 85, y: mix(18, 8, t), size: 24)
            Stick(x1: 85, y1: mix(32, 22, t), x2: 85, y2: mix(68, 58, t))
            Stick(x1: 85, y1: mix(68, 58, t), x2: 85, y2: 96)
            Box(x: 85, y: mix(12, 2, t), w: 40, h: 8, color: weightC.opacity(0.4), radius: 3)
        }
        .frame(width: 170, height: 115)
    }
}

// MARK: - 6. Chest Press
struct ChestPressAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 30, y: 55, w: 16, h: 55, color: machC)
            Dot(x: 30, y: 20, size: 24)
            Stick(x1: 30, y1: 33, x2: 30, y2: 80)
            Stick(x1: 35, y1: 48, x2: mix(60, 120, t), y2: 48)
            Box(x: mix(62, 122, t), y: 48, w: 7, h: 28, color: weightC)
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 7. Chest Fly
struct ChestFlyAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 52, w: 14, h: 45, color: machC)
            Dot(x: 85, y: 18, size: 24)
            Stick(x1: 85, y1: 45, x2: mix(40, 78, t), y2: mix(38, 45, t))
            Stick(x1: 85, y1: 45, x2: mix(130, 92, t), y2: mix(38, 45, t))
            Dot(x: mix(40, 78, t), y: mix(38, 45, t), size: 12, color: weightC.opacity(0.6))
            Dot(x: mix(130, 92, t), y: mix(38, 45, t), size: 12, color: weightC.opacity(0.6))
        }
        .frame(width: 170, height: 100)
    }
}

// MARK: - 8. Pulldown
struct PulldownAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Stick(x1: 85, y1: 5, x2: 85, y2: mix(15, 55, t), color: weightC.opacity(0.3), width: 2)
            Box(x: 85, y: mix(15, 55, t), w: 55, h: 6, color: weightC, radius: 2)
            Dot(x: 85, y: 32, size: 24)
            Stick(x1: 85, y1: 45, x2: 85, y2: 85)
            Stick(x1: 85, y1: 48, x2: 58, y2: mix(15, 55, t))
            Stick(x1: 85, y1: 48, x2: 112, y2: mix(15, 55, t))
            Box(x: 85, y: 92, w: 50, h: 12, color: machC)
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 9. Row
struct RowAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 105, y: 48, w: 12, h: 38, color: machC)
            Dot(x: 108, y: 18, size: 24)
            Stick(x1: 108, y1: 32, x2: 108, y2: 80)
            Stick(x1: 105, y1: 48, x2: mix(30, 85, t), y2: 48)
            Box(x: mix(30, 85, t), y: 48, w: 6, h: 20, color: weightC, radius: 3)
            Stick(x1: mix(30, 85, t), y1: 48, x2: 10, y2: 48, color: weightC.opacity(0.3), width: 2)
        }
        .frame(width: 170, height: 100)
    }
}

// MARK: - 10. Shoulder Press
struct ShoulderPressAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 88, w: 50, h: 14, color: machC)
            Box(x: 85, y: 60, w: 14, h: 42, color: machC)
            Dot(x: 85, y: 22, size: 24)
            Stick(x1: 80, y1: 42, x2: 65, y2: mix(42, 8, t))
            Stick(x1: 90, y1: 42, x2: 105, y2: mix(42, 8, t))
            Box(x: 65, y: mix(42, 8, t), w: 8, h: 14, color: weightC, radius: 3)
            Box(x: 105, y: mix(42, 8, t), w: 8, h: 14, color: weightC, radius: 3)
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 11. Lateral Raise
struct LateralRaiseAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Dot(x: 85, y: 15, size: 24)
            Stick(x1: 85, y1: 28, x2: 85, y2: 72)
            Stick(x1: 85, y1: 72, x2: 78, y2: 105)
            Stick(x1: 85, y1: 72, x2: 92, y2: 105)
            Stick(x1: 85, y1: 38, x2: mix(75, 38, t), y2: mix(62, 25, t))
            Stick(x1: 85, y1: 38, x2: mix(95, 132, t), y2: mix(62, 25, t))
            Dot(x: mix(75, 38, t), y: mix(62, 25, t), size: 10, color: weightC)
            Dot(x: mix(95, 132, t), y: mix(62, 25, t), size: 10, color: weightC)
        }
        .frame(width: 170, height: 115)
    }
}

// MARK: - 12. Bicep Curl
struct BicepCurlAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Dot(x: 80, y: 15, size: 24)
            Stick(x1: 80, y1: 28, x2: 80, y2: 72)
            Stick(x1: 80, y1: 72, x2: 72, y2: 105)
            Stick(x1: 80, y1: 72, x2: 88, y2: 105)
            // Upper arm
            Stick(x1: 83, y1: 40, x2: 100, y2: 58)
            // Forearm curling
            Stick(x1: 100, y1: 58, x2: mix(115, 90, t), y2: mix(85, 30, t))
            Box(x: mix(115, 90, t), y: mix(85, 30, t), w: 20, h: 7, color: weightC, radius: 3)
        }
        .frame(width: 170, height: 115)
    }
}

// MARK: - 13. Tricep Pushdown
struct TricepPushdownAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Stick(x1: 85, y1: 5, x2: 85, y2: mix(40, 75, t), color: weightC.opacity(0.3), width: 2)
            Box(x: 85, y: mix(40, 75, t), w: 28, h: 5, color: weightC, radius: 2)
            Dot(x: 85, y: 18, size: 24)
            Stick(x1: 85, y1: 30, x2: 85, y2: 75)
            // Upper arms
            Stick(x1: 82, y1: 38, x2: 78, y2: 55)
            Stick(x1: 88, y1: 38, x2: 92, y2: 55)
            // Forearms
            Stick(x1: 78, y1: 55, x2: 73, y2: mix(40, 75, t))
            Stick(x1: 92, y1: 55, x2: 97, y2: mix(40, 75, t))
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 14. Abdominal
struct AbdominalAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 72, w: 90, h: 12, color: machC)
            Dot(x: mix(38, 62, t), y: mix(52, 32, t), size: 22)
            Stick(x1: mix(45, 68, t), y1: mix(58, 42, t), x2: 85, y2: 62)
            Stick(x1: 85, y1: 62, x2: 108, y2: 42)
            Stick(x1: 108, y1: 42, x2: 118, y2: 62)
        }
        .frame(width: 170, height: 95)
    }
}

// MARK: - 15. Plank
struct PlankAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Stick(x1: 15, y1: 72, x2: 155, y2: 72, color: machC, width: 2)
            Stick(x1: 25, y1: mix(48, 52, t), x2: 130, y2: mix(48, 52, t), width: 5)
            Dot(x: 18, y: mix(38, 42, t), size: 20)
            Stick(x1: 42, y1: mix(48, 52, t), x2: 42, y2: 70)
            Stick(x1: 130, y1: mix(48, 52, t), x2: 134, y2: 70)
        }
        .frame(width: 170, height: 85)
    }
}

// MARK: - 16. Glute Kickback
struct GluteKickbackAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 62, y: 42, w: 12, h: 38, color: machC)
            Dot(x: 60, y: 12, size: 22)
            Stick(x1: 60, y1: 25, x2: 60, y2: 62)
            Stick(x1: 60, y1: 62, x2: 60, y2: 98)
            Stick(x1: 60, y1: 62, x2: mix(68, 115, t), y2: mix(95, 52, t))
            Dot(x: mix(68, 115, t), y: mix(95, 52, t), size: 12, color: weightC.opacity(0.6))
        }
        .frame(width: 170, height: 110)
    }
}

// MARK: - 17. Back Extension
struct BackExtensionAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Box(x: 85, y: 68, w: 30, h: 10, color: machC)
            Stick(x1: 88, y1: 65, x2: 115, y2: 90)
            Dot(x: mix(35, 52, t), y: mix(62, 28, t), size: 22)
            Stick(x1: mix(42, 58, t), y1: mix(68, 38, t), x2: 85, y2: 65)
        }
        .frame(width: 170, height: 105)
    }
}

// MARK: - 18. Face Pull
struct FacePullAnim: View {
    let t: CGFloat
    var body: some View {
        ZStack {
            Dot(x: 108, y: 15, size: 24)
            Stick(x1: 108, y1: 28, x2: 108, y2: 72)
            Stick(x1: 108, y1: 72, x2: 100, y2: 102)
            Stick(x1: 108, y1: 72, x2: 116, y2: 102)
            Stick(x1: 10, y1: 42, x2: mix(40, 88, t), y2: 42, color: weightC.opacity(0.3), width: 2)
            Stick(x1: 105, y1: 42, x2: mix(40, 88, t), y2: mix(32, 28, t))
            Stick(x1: 105, y1: 42, x2: mix(40, 88, t), y2: mix(52, 56, t))
            Dot(x: mix(40, 88, t), y: mix(32, 28, t), size: 8, color: weightC)
            Dot(x: mix(40, 88, t), y: mix(52, 56, t), size: 8, color: weightC)
        }
        .frame(width: 170, height: 115)
    }
}
