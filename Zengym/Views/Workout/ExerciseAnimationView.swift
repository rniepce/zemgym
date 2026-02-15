import SwiftUI

// MARK: - Exercise Animation Router
struct ExerciseAnimationView: View {
    let exerciseId: String
    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let progress = CGFloat((sin(elapsed * 2.0) + 1.0) / 2.0) // 0→1→0 smooth loop

            animationForExercise(progress: progress)
        }
    }

    @ViewBuilder
    private func animationForExercise(progress: CGFloat) -> some View {
        switch movementPattern {
        case .legPress:
            LegPressAnimation(p: progress)
        case .legExtension:
            LegExtensionAnimation(p: progress)
        case .legCurl:
            LegCurlAnimation(p: progress)
        case .hipAbduction:
            HipAbductionAnimation(p: progress)
        case .calfRaise:
            CalfRaiseAnimation(p: progress)
        case .chestPress:
            ChestPressAnimation(p: progress)
        case .chestFly:
            ChestFlyAnimation(p: progress)
        case .pulldown:
            PulldownAnimation(p: progress)
        case .row:
            RowAnimation(p: progress)
        case .shoulderPress:
            ShoulderPressAnimation(p: progress)
        case .lateralRaise:
            LateralRaiseAnimation(p: progress)
        case .bicepCurl:
            BicepCurlAnimation(p: progress)
        case .tricepPushdown:
            TricepPushdownAnimation(p: progress)
        case .abdominal:
            AbdominalAnimation(p: progress)
        case .plank:
            PlankAnimation(p: progress)
        case .gluteKickback:
            GluteKickbackAnimation(p: progress)
        case .backExtension:
            BackExtensionAnimation(p: progress)
        case .facePull:
            FacePullAnimation(p: progress)
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

// Lerp helper
private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    a + (b - a) * t
}

// MARK: - Stick Figure Colors
struct StickFigure {
    static let bodyColor = Color.zenMint
    static let machineColor = Color.zenBlue.opacity(0.3)
    static let weightColor = Color.zenBlue
    static let lw: CGFloat = 4
}

// MARK: - 1. Leg Press
struct LegPressAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Machine seat
            let seatRect = CGRect(x: cx - 70, y: cy - 5, width: 80, height: 25)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: seatRect), with: .color(StickFigure.machineColor))

            // Head
            let headCenter = CGPoint(x: cx - 50, y: cy - 25)
            ctx.fill(Circle().path(in: CGRect(x: headCenter.x - 12, y: headCenter.y - 12, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx - 50, y: cy - 10), to: CGPoint(x: cx - 20, y: cy + 15), color: StickFigure.bodyColor)

            // Hip joint
            let hip = CGPoint(x: cx - 20, y: cy + 15)

            // Knee position
            let kneeX = lerp(cx + 5, cx + 30, p)
            let kneeY = lerp(cy + 10, cy - 10, p)
            let knee = CGPoint(x: kneeX, y: kneeY)

            // Foot position
            let footX = lerp(cx + 25, cx + 45, p)
            let footY = lerp(cy - 5, cy - 20, p)
            let foot = CGPoint(x: footX, y: footY)

            // Upper leg
            drawLine(ctx, from: hip, to: knee, color: StickFigure.bodyColor)
            // Lower leg
            drawLine(ctx, from: knee, to: foot, color: StickFigure.bodyColor)

            // Platform
            let platRect = CGRect(x: footX - 5, y: footY - 25, width: 10, height: 50)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: platRect), with: .color(StickFigure.weightColor.opacity(0.4)))

            // Foot circle
            ctx.fill(Circle().path(in: CGRect(x: footX - 5, y: footY - 5, width: 10, height: 10)), with: .color(StickFigure.bodyColor))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 2. Leg Extension
struct LegExtensionAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Seat
            let seatRect = CGRect(x: cx - 45, y: cy + 5, width: 70, height: 20)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: seatRect), with: .color(StickFigure.machineColor))

            // Back support
            let backRect = CGRect(x: cx - 45, y: cy - 30, width: 18, height: 55)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: backRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 48, y: cy - 50, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx - 36, y: cy - 25), to: CGPoint(x: cx - 25, y: cy + 8), color: StickFigure.bodyColor)

            // Upper leg on seat
            let kneePoint = CGPoint(x: cx + 15, y: cy + 8)
            drawLine(ctx, from: CGPoint(x: cx - 25, y: cy + 8), to: kneePoint, color: StickFigure.bodyColor)

            // Lower leg (extending)
            let footX = lerp(cx + 20, cx + 55, p)
            let footY = lerp(cy + 40, cy + 8, p)
            drawLine(ctx, from: kneePoint, to: CGPoint(x: footX, y: footY), color: StickFigure.bodyColor)

            // Weight pad
            let padRect = CGRect(x: footX - 8, y: footY - 2, width: 18, height: 7)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: padRect), with: .color(StickFigure.weightColor.opacity(0.6)))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 3. Leg Curl
struct LegCurlAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Bench
            let benchRect = CGRect(x: cx - 55, y: cy + 2, width: 110, height: 16)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: benchRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 62, y: cy - 16, width: 22, height: 22)), with: .color(StickFigure.bodyColor))

            // Torso (lying)
            drawLine(ctx, from: CGPoint(x: cx - 42, y: cy - 2), to: CGPoint(x: cx + 5, y: cy - 2), color: StickFigure.bodyColor)

            // Upper leg
            drawLine(ctx, from: CGPoint(x: cx + 5, y: cy - 2), to: CGPoint(x: cx + 35, y: cy - 2), color: StickFigure.bodyColor)

            // Lower leg (curling up)
            let footX = lerp(cx + 55, cx + 25, p)
            let footY = lerp(cy - 2, cy - 35, p)
            drawLine(ctx, from: CGPoint(x: cx + 35, y: cy - 2), to: CGPoint(x: footX, y: footY), color: StickFigure.bodyColor)

            // Weight pad
            ctx.fill(Circle().path(in: CGRect(x: footX - 6, y: footY - 6, width: 12, height: 12)), with: .color(StickFigure.weightColor.opacity(0.6)))
        }
        .frame(width: 200, height: 110)
    }
}

// MARK: - 4. Hip Abduction/Adduction
struct HipAbductionAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Seat
            let seatRect = CGRect(x: cx - 25, y: cy, width: 50, height: 16)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: seatRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 48, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 22), to: CGPoint(x: cx, y: cy + 2), color: StickFigure.bodyColor)

            // Left leg
            let legSpread = lerp(12, 40, p)
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 2), to: CGPoint(x: cx - legSpread, y: cy + 45), color: StickFigure.bodyColor)

            // Right leg
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 2), to: CGPoint(x: cx + legSpread, y: cy + 45), color: StickFigure.bodyColor)

            // Knee pads
            ctx.fill(Circle().path(in: CGRect(x: cx - legSpread - 5, y: cy + 40, width: 10, height: 10)), with: .color(StickFigure.weightColor.opacity(0.5)))
            ctx.fill(Circle().path(in: CGRect(x: cx + legSpread - 5, y: cy + 40, width: 10, height: 10)), with: .color(StickFigure.weightColor.opacity(0.5)))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 5. Calf Raise
struct CalfRaiseAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let rise = lerp(0, -15, p)

            // Platform
            let platRect = CGRect(x: cx - 20, y: cy + 42, width: 40, height: 10)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: platRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 48 + rise, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 22 + rise), to: CGPoint(x: cx, y: cy + 15 + rise), color: StickFigure.bodyColor)

            // Legs
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 15 + rise), to: CGPoint(x: cx, y: cy + 40), color: StickFigure.bodyColor)

            // Feet
            let footRect = CGRect(x: cx - 10, y: cy + 38, width: 20, height: 7)
            ctx.fill(Capsule().path(in: footRect), with: .color(StickFigure.bodyColor))

            // Shoulder pads
            let padRect = CGRect(x: cx - 20, y: cy - 28 + rise, width: 40, height: 8)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: padRect), with: .color(StickFigure.weightColor.opacity(0.5)))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 6. Chest Press
struct ChestPressAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Seat back
            let backRect = CGRect(x: cx - 50, y: cy - 30, width: 18, height: 60)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: backRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 52, y: cy - 50, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx - 40, y: cy - 24), to: CGPoint(x: cx - 40, y: cy + 20), color: StickFigure.bodyColor)

            // Arms pushing handles
            let handX = lerp(cx - 15, cx + 35, p)
            drawLine(ctx, from: CGPoint(x: cx - 35, y: cy - 10), to: CGPoint(x: handX, y: cy - 10), color: StickFigure.bodyColor)

            // Weight handles
            let handleRect = CGRect(x: handX - 3, y: cy - 25, width: 7, height: 30)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: handleRect), with: .color(StickFigure.weightColor))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 7. Chest Fly (Peck Deck)
struct ChestFlyAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Back support
            let backRect = CGRect(x: cx - 8, y: cy - 30, width: 16, height: 50)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: backRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 52, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Arms spreading/closing
            let armSpread = lerp(8, 45, 1 - p)
            let armY = lerp(cy - 12, cy - 20, 1 - p)

            // Left arm
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 12), to: CGPoint(x: cx - armSpread, y: armY), color: StickFigure.bodyColor)
            // Right arm
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 12), to: CGPoint(x: cx + armSpread, y: armY), color: StickFigure.bodyColor)

            // Pads
            ctx.fill(Circle().path(in: CGRect(x: cx - armSpread - 6, y: armY - 6, width: 12, height: 12)), with: .color(StickFigure.weightColor.opacity(0.6)))
            ctx.fill(Circle().path(in: CGRect(x: cx + armSpread - 6, y: armY - 6, width: 12, height: 12)), with: .color(StickFigure.weightColor.opacity(0.6)))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 8. Pulldown
struct PulldownAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Cable from top
            let barY = lerp(cy - 45, cy - 5, p)
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 55), to: CGPoint(x: cx, y: barY), color: StickFigure.weightColor.opacity(0.3), width: 2)

            // Bar
            let barRect = CGRect(x: cx - 30, y: barY - 3, width: 60, height: 6)
            ctx.fill(RoundedRectangle(cornerRadius: 2).path(in: barRect), with: .color(StickFigure.weightColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 35, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 10), to: CGPoint(x: cx, y: cy + 25), color: StickFigure.bodyColor)

            // Arms to bar
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 8), to: CGPoint(x: cx - 28, y: barY), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 8), to: CGPoint(x: cx + 28, y: barY), color: StickFigure.bodyColor)

            // Seat
            let seatRect = CGRect(x: cx - 25, y: cy + 28, width: 50, height: 12)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: seatRect), with: .color(StickFigure.machineColor))
        }
        .frame(width: 200, height: 140)
    }
}

// MARK: - 9. Row
struct RowAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Chest pad
            let padRect = CGRect(x: cx + 5, y: cy - 25, width: 12, height: 40)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: padRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx + 2, y: cy - 48, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx + 14, y: cy - 22), to: CGPoint(x: cx + 14, y: cy + 20), color: StickFigure.bodyColor)

            // Handle position
            let handleX = lerp(cx - 45, cx - 5, p)

            // Arms pulling
            drawLine(ctx, from: CGPoint(x: cx + 10, y: cy - 8), to: CGPoint(x: handleX, y: cy - 8), color: StickFigure.bodyColor)

            // Handle
            let handleRect = CGRect(x: handleX - 3, y: cy - 18, width: 6, height: 20)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: handleRect), with: .color(StickFigure.weightColor))

            // Cable
            drawLine(ctx, from: CGPoint(x: handleX, y: cy - 8), to: CGPoint(x: cx - 60, y: cy - 8), color: StickFigure.weightColor.opacity(0.3), width: 2)
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 10. Shoulder Press
struct ShoulderPressAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Seat + back
            let seatRect = CGRect(x: cx - 25, y: cy + 20, width: 50, height: 14)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: seatRect), with: .color(StickFigure.machineColor))
            let backRect = CGRect(x: cx - 8, y: cy - 20, width: 16, height: 45)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: backRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 42, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Arms pushing up
            let handY = lerp(cy - 15, cy - 52, p)

            drawLine(ctx, from: CGPoint(x: cx - 5, y: cy - 15), to: CGPoint(x: cx - 22, y: handY), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 5, y: cy - 15), to: CGPoint(x: cx + 22, y: handY), color: StickFigure.bodyColor)

            // Handles
            let lhRect = CGRect(x: cx - 26, y: handY - 6, width: 8, height: 14)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: lhRect), with: .color(StickFigure.weightColor))
            let rhRect = CGRect(x: cx + 18, y: handY - 6, width: 8, height: 14)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: rhRect), with: .color(StickFigure.weightColor))
        }
        .frame(width: 200, height: 140)
    }
}

// MARK: - 11. Lateral Raise
struct LateralRaiseAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 48, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 22), to: CGPoint(x: cx, y: cy + 18), color: StickFigure.bodyColor)

            // Legs
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 18), to: CGPoint(x: cx - 10, y: cy + 48), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 18), to: CGPoint(x: cx + 10, y: cy + 48), color: StickFigure.bodyColor)

            // Arms raising
            let armX = lerp(10, 48, p)
            let armY = lerp(cy + 8, cy - 25, p)

            drawLine(ctx, from: CGPoint(x: cx, y: cy - 14), to: CGPoint(x: cx - armX, y: armY), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 14), to: CGPoint(x: cx + armX, y: armY), color: StickFigure.bodyColor)

            // Weights
            ctx.fill(Circle().path(in: CGRect(x: cx - armX - 5, y: armY - 5, width: 10, height: 10)), with: .color(StickFigure.weightColor))
            ctx.fill(Circle().path(in: CGRect(x: cx + armX - 5, y: armY - 5, width: 10, height: 10)), with: .color(StickFigure.weightColor))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 12. Bicep Curl
struct BicepCurlAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 48, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 22), to: CGPoint(x: cx, y: cy + 18), color: StickFigure.bodyColor)

            // Legs
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 18), to: CGPoint(x: cx - 8, y: cy + 48), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx, y: cy + 18), to: CGPoint(x: cx + 8, y: cy + 48), color: StickFigure.bodyColor)

            // Upper arm (fixed at side)
            let elbowR = CGPoint(x: cx + 18, y: cy + 5)
            drawLine(ctx, from: CGPoint(x: cx + 3, y: cy - 12), to: elbowR, color: StickFigure.bodyColor)

            // Forearm (curling)
            let handX = lerp(cx + 32, cx + 10, p)
            let handY = lerp(cy + 30, cy - 18, p)
            drawLine(ctx, from: elbowR, to: CGPoint(x: handX, y: handY), color: StickFigure.bodyColor)

            // Weight
            let wRect = CGRect(x: handX - 10, y: handY - 3, width: 20, height: 7)
            ctx.fill(RoundedRectangle(cornerRadius: 3).path(in: wRect), with: .color(StickFigure.weightColor))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - 13. Tricep Pushdown
struct TricepPushdownAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Cable from top
            let barY = lerp(cy - 20, cy + 20, p)
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 55), to: CGPoint(x: cx, y: barY), color: StickFigure.weightColor.opacity(0.3), width: 2)

            // Bar
            let barRect = CGRect(x: cx - 15, y: barY - 3, width: 30, height: 6)
            ctx.fill(RoundedRectangle(cornerRadius: 2).path(in: barRect), with: .color(StickFigure.weightColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 12, y: cy - 45, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx, y: cy - 20), to: CGPoint(x: cx, y: cy + 20), color: StickFigure.bodyColor)

            // Upper arms (close to body)
            drawLine(ctx, from: CGPoint(x: cx - 3, y: cy - 12), to: CGPoint(x: cx - 5, y: cy + 2), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 3, y: cy - 12), to: CGPoint(x: cx + 5, y: cy + 2), color: StickFigure.bodyColor)

            // Forearms (pushing down)
            drawLine(ctx, from: CGPoint(x: cx - 5, y: cy + 2), to: CGPoint(x: cx - 12, y: barY), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 5, y: cy + 2), to: CGPoint(x: cx + 12, y: barY), color: StickFigure.bodyColor)
        }
        .frame(width: 200, height: 140)
    }
}

// MARK: - 14. Abdominal
struct AbdominalAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Bench
            let benchRect = CGRect(x: cx - 45, y: cy + 10, width: 90, height: 14)
            ctx.fill(RoundedRectangle(cornerRadius: 6).path(in: benchRect), with: .color(StickFigure.machineColor))

            // Head (crunching up)
            let headX = lerp(cx - 38, cx - 18, p)
            let headY = lerp(cy - 3, cy - 22, p)
            ctx.fill(Circle().path(in: CGRect(x: headX - 10, y: headY - 10, width: 20, height: 20)), with: .color(StickFigure.bodyColor))

            // Torso (crunching)
            let shoulderX = lerp(cx - 32, cx - 12, p)
            let shoulderY = lerp(cy + 5, cy - 8, p)
            drawLine(ctx, from: CGPoint(x: shoulderX, y: shoulderY), to: CGPoint(x: cx + 5, y: cy + 8), color: StickFigure.bodyColor)

            // Legs (bent, fixed)
            drawLine(ctx, from: CGPoint(x: cx + 5, y: cy + 8), to: CGPoint(x: cx + 25, y: cy - 8), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 25, y: cy - 8), to: CGPoint(x: cx + 35, y: cy + 8), color: StickFigure.bodyColor)
        }
        .frame(width: 200, height: 110)
    }
}

// MARK: - 15. Plank
struct PlankAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let pulse = lerp(-2, 2, p)

            // Ground
            drawLine(ctx, from: CGPoint(x: cx - 65, y: cy + 18), to: CGPoint(x: cx + 65, y: cy + 18), color: StickFigure.machineColor, width: 2)

            // Body line
            drawLine(ctx, from: CGPoint(x: cx - 45, y: cy + pulse), to: CGPoint(x: cx + 40, y: cy + pulse), color: StickFigure.bodyColor, width: 5)

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 57, y: cy - 12 + pulse, width: 20, height: 20)), with: .color(StickFigure.bodyColor))

            // Arms
            drawLine(ctx, from: CGPoint(x: cx - 30, y: cy + pulse), to: CGPoint(x: cx - 30, y: cy + 16), color: StickFigure.bodyColor)

            // Feet
            drawLine(ctx, from: CGPoint(x: cx + 40, y: cy + pulse), to: CGPoint(x: cx + 44, y: cy + 16), color: StickFigure.bodyColor)

            // Core glow
            let glowRect = CGRect(x: cx - 15, y: cy - 6 + pulse, width: 30, height: 12)
            ctx.fill(Capsule().path(in: glowRect), with: .color(StickFigure.bodyColor.opacity(lerp(0.1, 0.35, p))))
        }
        .frame(width: 200, height: 80)
    }
}

// MARK: - 16. Glute Kickback
struct GluteKickbackAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Machine pad
            let padRect = CGRect(x: cx - 18, y: cy - 22, width: 12, height: 40)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: padRect), with: .color(StickFigure.machineColor))

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx - 22, y: cy - 46, width: 22, height: 22)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx - 12, y: cy - 22), to: CGPoint(x: cx - 12, y: cy + 12), color: StickFigure.bodyColor)

            // Standing leg
            drawLine(ctx, from: CGPoint(x: cx - 12, y: cy + 12), to: CGPoint(x: cx - 12, y: cy + 42), color: StickFigure.bodyColor)

            // Kicking leg
            let kickX = lerp(cx - 2, cx + 38, p)
            let kickY = lerp(cy + 38, cy + 2, p)
            drawLine(ctx, from: CGPoint(x: cx - 12, y: cy + 12), to: CGPoint(x: kickX, y: kickY), color: StickFigure.bodyColor)

            // Weight pad
            ctx.fill(Circle().path(in: CGRect(x: kickX - 6, y: kickY - 6, width: 12, height: 12)), with: .color(StickFigure.weightColor.opacity(0.6)))
        }
        .frame(width: 200, height: 120)
    }
}

// MARK: - 17. Back Extension
struct BackExtensionAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Pad
            let padRect = CGRect(x: cx - 5, y: cy + 5, width: 30, height: 12)
            ctx.fill(RoundedRectangle(cornerRadius: 4).path(in: padRect), with: .color(StickFigure.machineColor))

            // Legs (fixed)
            drawLine(ctx, from: CGPoint(x: cx + 5, y: cy + 10), to: CGPoint(x: cx + 35, y: cy + 35), color: StickFigure.bodyColor)

            // Torso (extending up)
            let headX = lerp(cx - 42, cx - 30, p)
            let headY = lerp(cy + 8, cy - 28, p)
            let shoulderX = lerp(cx - 35, cx - 22, p)
            let shoulderY = lerp(cy + 12, cy - 15, p)

            drawLine(ctx, from: CGPoint(x: shoulderX, y: shoulderY), to: CGPoint(x: cx + 5, y: cy + 10), color: StickFigure.bodyColor)

            // Head
            ctx.fill(Circle().path(in: CGRect(x: headX - 10, y: headY - 10, width: 22, height: 22)), with: .color(StickFigure.bodyColor))
        }
        .frame(width: 200, height: 110)
    }
}

// MARK: - 18. Face Pull
struct FacePullAnimation: View {
    let p: CGFloat

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Head
            ctx.fill(Circle().path(in: CGRect(x: cx + 2, y: cy - 45, width: 24, height: 24)), with: .color(StickFigure.bodyColor))

            // Torso
            drawLine(ctx, from: CGPoint(x: cx + 14, y: cy - 20), to: CGPoint(x: cx + 14, y: cy + 18), color: StickFigure.bodyColor)

            // Legs
            drawLine(ctx, from: CGPoint(x: cx + 14, y: cy + 18), to: CGPoint(x: cx + 6, y: cy + 46), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 14, y: cy + 18), to: CGPoint(x: cx + 22, y: cy + 46), color: StickFigure.bodyColor)

            // Rope handle positions
            let ropeX = lerp(cx - 30, cx - 2, p)
            let ropeTopY = lerp(cy - 15, cy - 28, p)
            let ropeBotY = lerp(cy - 15, cy - 5, p)

            // Cable
            drawLine(ctx, from: CGPoint(x: cx - 55, y: cy - 15), to: CGPoint(x: ropeX, y: cy - 15), color: StickFigure.weightColor.opacity(0.3), width: 2)

            // Arms pulling
            drawLine(ctx, from: CGPoint(x: cx + 10, y: cy - 15), to: CGPoint(x: ropeX, y: ropeTopY), color: StickFigure.bodyColor)
            drawLine(ctx, from: CGPoint(x: cx + 10, y: cy - 15), to: CGPoint(x: ropeX, y: ropeBotY), color: StickFigure.bodyColor)

            // Rope ends
            ctx.fill(Circle().path(in: CGRect(x: ropeX - 4, y: ropeTopY - 4, width: 8, height: 8)), with: .color(StickFigure.weightColor))
            ctx.fill(Circle().path(in: CGRect(x: ropeX - 4, y: ropeBotY - 4, width: 8, height: 8)), with: .color(StickFigure.weightColor))
        }
        .frame(width: 200, height: 130)
    }
}

// MARK: - Canvas Drawing Helper
private func drawLine(_ ctx: GraphicsContext, from: CGPoint, to: CGPoint, color: Color, width: CGFloat = 4) {
    var path = Path()
    path.move(to: from)
    path.addLine(to: to)
    ctx.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: width, lineCap: .round))
}
