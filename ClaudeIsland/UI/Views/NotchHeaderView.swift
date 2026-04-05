//
//  NotchHeaderView.swift
//  ClaudeIsland
//
//  Header bar for the dynamic island
//

import Combine
import SwiftUI

struct ClaudeCrabIcon: View {
    let size: CGFloat
    let color: Color
    var animateLegs: Bool = false

    @State private var legPhase: Int = 0

    // Timer for leg animation
    private let legTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    init(size: CGFloat = 16, color: Color = Color(red: 0.85, green: 0.47, blue: 0.34), animateLegs: Bool = false) {
        self.size = size
        self.color = color
        self.animateLegs = animateLegs
    }

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 52.0  // Original viewBox height is 52
            let xOffset = (canvasSize.width - 66 * scale) / 2

            // Left antenna
            let leftAntenna = Path { p in
                p.addRect(CGRect(x: 0, y: 13, width: 6, height: 13))
            }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
            context.fill(leftAntenna, with: .color(color))

            // Right antenna
            let rightAntenna = Path { p in
                p.addRect(CGRect(x: 60, y: 13, width: 6, height: 13))
            }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
            context.fill(rightAntenna, with: .color(color))

            // Animated legs - alternating up/down pattern for walking effect
            // Legs stay attached to body (y=39), only height changes
            let baseLegPositions: [CGFloat] = [6, 18, 42, 54]
            let baseLegHeight: CGFloat = 13

            // Height offsets: positive = longer leg (down), negative = shorter leg (up)
            let legHeightOffsets: [[CGFloat]] = [
                [3, -3, 3, -3],   // Phase 0: alternating
                [0, 0, 0, 0],     // Phase 1: neutral
                [-3, 3, -3, 3],   // Phase 2: alternating (opposite)
                [0, 0, 0, 0],     // Phase 3: neutral
            ]

            let currentHeightOffsets = animateLegs ? legHeightOffsets[legPhase % 4] : [CGFloat](repeating: 0, count: 4)

            for (index, xPos) in baseLegPositions.enumerated() {
                let heightOffset = currentHeightOffsets[index]
                let legHeight = baseLegHeight + heightOffset
                let leg = Path { p in
                    p.addRect(CGRect(x: xPos, y: 39, width: 6, height: legHeight))
                }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
                context.fill(leg, with: .color(color))
            }

            // Main body
            let body = Path { p in
                p.addRect(CGRect(x: 6, y: 0, width: 54, height: 39))
            }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
            context.fill(body, with: .color(color))

            // Left eye
            let leftEye = Path { p in
                p.addRect(CGRect(x: 12, y: 13, width: 6, height: 6.5))
            }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
            context.fill(leftEye, with: .color(.black))

            // Right eye
            let rightEye = Path { p in
                p.addRect(CGRect(x: 48, y: 13, width: 6, height: 6.5))
            }.applying(CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xOffset / scale, y: 0))
            context.fill(rightEye, with: .color(.black))
        }
        .frame(width: size * (66.0 / 52.0), height: size)
        .onReceive(legTimer) { _ in
            if animateLegs {
                legPhase = (legPhase + 1) % 4
            }
        }
    }
}

// MARK: - Owl Icon (pixel art)
struct OwlIcon: View {
    let size: CGFloat
    let color: Color
    var animateWings: Bool = false

    @State private var wingPhase: Int = 0
    private let wingTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    init(size: CGFloat = 16, color: Color = Color(red: 0.65, green: 0.55, blue: 0.40), animateWings: Bool = false) {
        self.size = size
        self.color = color
        self.animateWings = animateWings
    }

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 52.0
            let xOffset = (canvasSize.width - 52 * scale) / 2

            let t = CGAffineTransform(scaleX: scale, y: scale)
                .translatedBy(x: xOffset / scale, y: 0)

            func fill(_ rect: CGRect, _ c: Color) {
                context.fill(Path(rect).applying(t), with: .color(c))
            }

            // Ear tufts
            fill(CGRect(x: 6, y: 0, width: 6, height: 6), color)
            fill(CGRect(x: 40, y: 0, width: 6, height: 6), color)

            // Head
            fill(CGRect(x: 12, y: 0, width: 28, height: 26), color)

            // Eyes (large round owl eyes)
            fill(CGRect(x: 14, y: 8, width: 10, height: 10), .white)
            fill(CGRect(x: 28, y: 8, width: 10, height: 10), .white)
            // Pupils
            fill(CGRect(x: 18, y: 12, width: 4, height: 4), .black)
            fill(CGRect(x: 30, y: 12, width: 4, height: 4), .black)

            // Beak
            fill(CGRect(x: 22, y: 18, width: 8, height: 6), Color(red: 0.9, green: 0.7, blue: 0.2))

            // Body
            fill(CGRect(x: 14, y: 26, width: 24, height: 18), color)

            // Chest pattern (lighter)
            fill(CGRect(x: 20, y: 28, width: 12, height: 14), color.opacity(0.6))

            // Wings (animated)
            let wingOffset: CGFloat = animateWings ? (wingPhase % 2 == 0 ? -2 : 2) : 0
            fill(CGRect(x: 6, y: 28 + wingOffset, width: 8, height: 14), color)
            fill(CGRect(x: 38, y: 28 - wingOffset, width: 8, height: 14), color)

            // Feet
            fill(CGRect(x: 16, y: 44, width: 6, height: 6), Color(red: 0.9, green: 0.7, blue: 0.2))
            fill(CGRect(x: 30, y: 44, width: 6, height: 6), Color(red: 0.9, green: 0.7, blue: 0.2))
        }
        .frame(width: size, height: size)
        .onReceive(wingTimer) { _ in
            if animateWings { wingPhase = (wingPhase + 1) % 4 }
        }
    }
}

// MARK: - Cat Icon (pixel art)
struct CatIcon: View {
    let size: CGFloat
    let color: Color
    var animateTail: Bool = false

    @State private var tailPhase: Int = 0
    private let tailTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    init(size: CGFloat = 16, color: Color = Color(red: 0.80, green: 0.60, blue: 0.30), animateTail: Bool = false) {
        self.size = size
        self.color = color
        self.animateTail = animateTail
    }

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 52.0
            let xOffset = (canvasSize.width - 52 * scale) / 2

            let t = CGAffineTransform(scaleX: scale, y: scale)
                .translatedBy(x: xOffset / scale, y: 0)

            func fill(_ rect: CGRect, _ c: Color) {
                context.fill(Path(rect).applying(t), with: .color(c))
            }

            // Ears (triangular via stacked rects)
            fill(CGRect(x: 8, y: 0, width: 6, height: 6), color)
            fill(CGRect(x: 6, y: 6, width: 10, height: 4), color)
            fill(CGRect(x: 36, y: 0, width: 6, height: 6), color)
            fill(CGRect(x: 36, y: 6, width: 10, height: 4), color)

            // Inner ears (pink)
            let earPink = Color(red: 1.0, green: 0.6, blue: 0.7)
            fill(CGRect(x: 10, y: 2, width: 3, height: 4), earPink)
            fill(CGRect(x: 38, y: 2, width: 3, height: 4), earPink)

            // Head
            fill(CGRect(x: 8, y: 10, width: 36, height: 18), color)

            // Eyes
            fill(CGRect(x: 14, y: 14, width: 6, height: 5), Color(red: 0.4, green: 0.8, blue: 0.4))
            fill(CGRect(x: 32, y: 14, width: 6, height: 5), Color(red: 0.4, green: 0.8, blue: 0.4))
            // Pupils (vertical slit)
            fill(CGRect(x: 16, y: 14, width: 2, height: 5), .black)
            fill(CGRect(x: 34, y: 14, width: 2, height: 5), .black)

            // Nose
            fill(CGRect(x: 24, y: 20, width: 4, height: 3), earPink)

            // Body
            fill(CGRect(x: 12, y: 28, width: 28, height: 16), color)

            // Front legs
            fill(CGRect(x: 14, y: 44, width: 6, height: 8), color)
            fill(CGRect(x: 32, y: 44, width: 6, height: 8), color)

            // Tail (animated wave)
            let tailX: CGFloat = animateTail ? (tailPhase % 2 == 0 ? 42 : 44) : 42
            fill(CGRect(x: tailX, y: 30, width: 6, height: 6), color)
            fill(CGRect(x: tailX + 2, y: 24, width: 6, height: 6), color)
        }
        .frame(width: size, height: size)
        .onReceive(tailTimer) { _ in
            if animateTail { tailPhase = (tailPhase + 1) % 4 }
        }
    }
}

// MARK: - Fox Icon (pixel art)
struct FoxIcon: View {
    let size: CGFloat
    let color: Color
    var animateTail: Bool = false

    @State private var tailPhase: Int = 0
    private let tailTimer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    init(size: CGFloat = 16, color: Color = Color(red: 0.90, green: 0.50, blue: 0.20), animateTail: Bool = false) {
        self.size = size
        self.color = color
        self.animateTail = animateTail
    }

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 52.0
            let xOffset = (canvasSize.width - 52 * scale) / 2

            let t = CGAffineTransform(scaleX: scale, y: scale)
                .translatedBy(x: xOffset / scale, y: 0)

            func fill(_ rect: CGRect, _ c: Color) {
                context.fill(Path(rect).applying(t), with: .color(c))
            }

            let white = Color.white

            // Ears (large pointed)
            fill(CGRect(x: 4, y: 0, width: 10, height: 10), color)
            fill(CGRect(x: 38, y: 0, width: 10, height: 10), color)

            // Head
            fill(CGRect(x: 8, y: 8, width: 36, height: 20), color)

            // White muzzle
            fill(CGRect(x: 16, y: 16, width: 20, height: 12), white)

            // Eyes
            fill(CGRect(x: 14, y: 12, width: 6, height: 5), .black)
            fill(CGRect(x: 32, y: 12, width: 6, height: 5), .black)
            // Eye shine
            fill(CGRect(x: 16, y: 12, width: 2, height: 2), white)
            fill(CGRect(x: 34, y: 12, width: 2, height: 2), white)

            // Nose
            fill(CGRect(x: 23, y: 18, width: 6, height: 4), .black)

            // Body
            fill(CGRect(x: 12, y: 28, width: 28, height: 16), color)

            // White belly
            fill(CGRect(x: 18, y: 30, width: 16, height: 12), white)

            // Legs
            fill(CGRect(x: 14, y: 44, width: 6, height: 8), color)
            fill(CGRect(x: 32, y: 44, width: 6, height: 8), color)

            // Bushy tail (animated sway)
            let tailY: CGFloat = animateTail ? (tailPhase % 2 == 0 ? 22 : 26) : 24
            fill(CGRect(x: 42, y: tailY, width: 8, height: 12), color)
            fill(CGRect(x: 44, y: tailY + 10, width: 6, height: 4), white)
        }
        .frame(width: size, height: size)
        .onReceive(tailTimer) { _ in
            if animateTail { tailPhase = (tailPhase + 1) % 4 }
        }
    }
}

// MARK: - Octopus Icon (pixel art)
struct OctopusIcon: View {
    let size: CGFloat
    let color: Color
    var animateTentacles: Bool = false

    @State private var tentaclePhase: Int = 0
    private let tentacleTimer = Timer.publish(every: 0.18, on: .main, in: .common).autoconnect()

    init(size: CGFloat = 16, color: Color = Color(red: 0.60, green: 0.40, blue: 0.75), animateTentacles: Bool = false) {
        self.size = size
        self.color = color
        self.animateTentacles = animateTentacles
    }

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 52.0
            let xOffset = (canvasSize.width - 52 * scale) / 2

            let t = CGAffineTransform(scaleX: scale, y: scale)
                .translatedBy(x: xOffset / scale, y: 0)

            func fill(_ rect: CGRect, _ c: Color) {
                context.fill(Path(rect).applying(t), with: .color(c))
            }

            // Head (round dome)
            fill(CGRect(x: 10, y: 0, width: 32, height: 8), color)
            fill(CGRect(x: 6, y: 8, width: 40, height: 18), color)

            // Eyes
            fill(CGRect(x: 14, y: 12, width: 8, height: 8), .white)
            fill(CGRect(x: 30, y: 12, width: 8, height: 8), .white)
            // Pupils
            fill(CGRect(x: 18, y: 14, width: 4, height: 4), .black)
            fill(CGRect(x: 32, y: 14, width: 4, height: 4), .black)

            // Mouth
            fill(CGRect(x: 22, y: 22, width: 8, height: 3), color.opacity(0.5))

            // Tentacles (8 legs, animated wave)
            let offsets: [CGFloat] = animateTentacles
                ? [0, 1, 2, 3, 3, 2, 1, 0].map { phase in
                    let shift = (tentaclePhase % 4)
                    return (phase + CGFloat(shift)).truncatingRemainder(dividingBy: 4) - 2
                }
                : [CGFloat](repeating: 0, count: 8)

            let tentacleXPositions: [CGFloat] = [4, 10, 18, 24, 28, 34, 40, 46]
            for (i, xPos) in tentacleXPositions.enumerated() {
                let yOff = offsets[i] * 2
                fill(CGRect(x: xPos, y: 26 + yOff, width: 4, height: 10), color)
                fill(CGRect(x: xPos + (i < 4 ? -2 : 2), y: 34 + yOff, width: 4, height: 8), color)
            }
        }
        .frame(width: size, height: size)
        .onReceive(tentacleTimer) { _ in
            if animateTentacles { tentaclePhase = (tentaclePhase + 1) % 4 }
        }
    }
}

// MARK: - Unified Creature Icon (dispatches to the selected creature)
struct NotchCreatureIcon: View {
    let creature: NotchCreature
    let size: CGFloat
    var animate: Bool = false

    // Standard frame width matches crab's wider ratio (66x52 coordinate space)
    private var standardWidth: CGFloat { size * (66.0 / 52.0) }

    var body: some View {
        let c = creature.defaultColor
        let color = Color(red: c.red, green: c.green, blue: c.blue)

        Group {
            switch creature {
            case .crab:
                ClaudeCrabIcon(size: size, color: color, animateLegs: animate)
            case .owl:
                OwlIcon(size: size, color: color, animateWings: animate)
            case .cat:
                CatIcon(size: size, color: color, animateTail: animate)
            case .fox:
                FoxIcon(size: size, color: color, animateTail: animate)
            case .octopus:
                OctopusIcon(size: size, color: color, animateTentacles: animate)
            }
        }
        .frame(width: standardWidth, height: size)
    }
}

// Pixel art permission indicator icon
struct PermissionIndicatorIcon: View {
    let size: CGFloat
    let color: Color

    init(size: CGFloat = 14, color: Color = Color(red: 0.11, green: 0.12, blue: 0.13)) {
        self.size = size
        self.color = color
    }

    // Visible pixel positions from the SVG (at 30x30 scale)
    private let pixels: [(CGFloat, CGFloat)] = [
        (7, 7), (7, 11),           // Left column
        (11, 3),                    // Top left
        (15, 3), (15, 19), (15, 27), // Center column
        (19, 3), (19, 15),          // Right of center
        (23, 7), (23, 11)           // Right column
    ]

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 30.0
            let pixelSize: CGFloat = 4 * scale

            for (x, y) in pixels {
                let rect = CGRect(
                    x: x * scale - pixelSize / 2,
                    y: y * scale - pixelSize / 2,
                    width: pixelSize,
                    height: pixelSize
                )
                context.fill(Path(rect), with: .color(color))
            }
        }
        .frame(width: size, height: size)
    }
}

// Pixel art "ready for input" indicator icon (checkmark/done shape)
struct ReadyForInputIndicatorIcon: View {
    let size: CGFloat
    let color: Color

    init(size: CGFloat = 14, color: Color = TerminalColors.green) {
        self.size = size
        self.color = color
    }

    // Checkmark shape pixel positions (at 30x30 scale)
    private let pixels: [(CGFloat, CGFloat)] = [
        (5, 15),                    // Start of checkmark
        (9, 19),                    // Down stroke
        (13, 23),                   // Bottom of checkmark
        (17, 19),                   // Up stroke begins
        (21, 15),                   // Up stroke
        (25, 11),                   // Up stroke
        (29, 7)                     // End of checkmark
    ]

    var body: some View {
        Canvas { context, canvasSize in
            let scale = size / 30.0
            let pixelSize: CGFloat = 4 * scale

            for (x, y) in pixels {
                let rect = CGRect(
                    x: x * scale - pixelSize / 2,
                    y: y * scale - pixelSize / 2,
                    width: pixelSize,
                    height: pixelSize
                )
                context.fill(Path(rect), with: .color(color))
            }
        }
        .frame(width: size, height: size)
    }
}

