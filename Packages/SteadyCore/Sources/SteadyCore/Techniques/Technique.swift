import Foundation

/// The down-regulation techniques available in Stage 2. Order matters: `physiologicalSigh` is the evidence-based default.
public enum TechniqueKind: String, Codable, Sendable, CaseIterable, Identifiable {
    case physiologicalSigh, pacedBreathing, coldWater, movement, orienting, sound
    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .physiologicalSigh: "Steady"
        case .pacedBreathing: "Slow breathing"
        case .coldWater: "Cold water"
        case .movement: "Move"
        case .orienting: "Look around"
        case .sound: "Sound"
        }
    }

    /// Techniques that require a one-time safety acknowledgment before they appear.
    public var requiresSafetyGate: Bool { self == .coldWater || self == .movement }
}

/// One phase of a breathing pattern. Durations in seconds.
public struct BreathPhase: Sendable, Equatable {
    public enum Kind: String, Sendable { case inhale, topOff, exhale, hold }
    public let kind: Kind
    public let seconds: Double
    public let cue: String
    public init(kind: Kind, seconds: Double, cue: String) { self.kind = kind; self.seconds = seconds; self.cue = cue }
}

/// A repeating breathing pattern. Pure value type so the same timing drives iPhone haptics, Watch haptics, voice, and UI.
public struct BreathPattern: Sendable, Equatable {
    public let name: String
    public let phases: [BreathPhase]
    public let cycles: Int
    public let hapticAssetName: String

    public init(name: String, phases: [BreathPhase], cycles: Int, hapticAssetName: String) {
        self.name = name; self.phases = phases; self.cycles = cycles; self.hapticAssetName = hapticAssetName
    }

    public var cycleDuration: Double { phases.reduce(0) { $0 + $1.seconds } }
    public var totalDuration: Double { cycleDuration * Double(cycles) }

    /// Appendix A.1: physiological sigh. Inhale ~2 s, top-off ~1 s, long exhale ~7 s. Three cycles (~30 s).
    public static let physiologicalSigh = BreathPattern(
        name: "Physiological sigh",
        phases: [
            .init(kind: .inhale, seconds: 2.0, cue: "In."),
            .init(kind: .topOff, seconds: 1.0, cue: "A little more."),
            .init(kind: .exhale, seconds: 7.0, cue: "Long slow out.")
        ],
        cycles: 3,
        hapticAssetName: "sigh"
    )

    /// Appendix A.2: paced breathing at `breathsPerMinute` (default 5.5). Inhale:exhale ≈ 4:7, no holds.
    public static func paced(breathsPerMinute bpm: Double = 5.5, seconds total: Double = 90) -> BreathPattern {
        let clamped = min(6.5, max(4.5, bpm))
        let cycle = 60.0 / clamped
        let inhale = cycle * (4.0 / 11.0)
        let exhale = cycle - inhale
        let cycles = max(1, Int((total / cycle).rounded()))
        return BreathPattern(
            name: "Paced breathing",
            phases: [
                .init(kind: .inhale, seconds: inhale, cue: "In."),
                .init(kind: .exhale, seconds: exhale, cue: "Out.")
            ],
            cycles: cycles,
            hapticAssetName: "paced"
        )
    }

    /// Timeline of (offsetSeconds, phase) across all cycles. Drives haptics/voice scheduling.
    public func timeline() -> [(offset: Double, phase: BreathPhase)] {
        var out: [(Double, BreathPhase)] = []
        var t = 0.0
        for _ in 0..<cycles {
            for ph in phases { out.append((t, ph)); t += ph.seconds }
        }
        return out.map { (offset: $0.0, phase: $0.1) }
    }
}

/// The five-stage reset arc (PRD 5.1). The app never skips forward.
public enum ResetStage: Int, Sendable, CaseIterable {
    case interrupt = 1, downRegulate, name, reorient, returnStage
}

/// The default Stage 2 sequence: three sighs, then paced breathing.
public struct DefaultDownRegulation: Sendable {
    public let sigh: BreathPattern
    public let paced: BreathPattern
    public init(pacedBreathsPerMinute: Double = 5.5) {
        sigh = .physiologicalSigh
        paced = .paced(breathsPerMinute: pacedBreathsPerMinute)
    }
    public var totalDuration: Double { sigh.totalDuration + paced.totalDuration }
}
