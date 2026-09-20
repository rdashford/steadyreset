import CoreHaptics
import Foundation
import SteadyCore

/// D1/D7: haptic-led breathing. Patterns live in Resources/Haptics/*.ahap and are timed to BreathPattern.
/// Prewarmed at launch so first cue lands within the ≤2 s budget.
/// Main-actor isolated: every call site is UI (RootView's prewarm task, ResetView's
/// play/stop), so isolation costs no suspension on the launch path that E1 budgets.
@MainActor
final class HapticEngine {
    static let shared = HapticEngine()
    private var engine: CHHapticEngine?
    private var player: CHHapticAdvancedPatternPlayer?
    /// Held so a new pattern can cancel the previous pattern's pending stop.
    /// Without this an orphaned timer silently stops a later reset (rule 1).
    private var stopTask: Task<Void, Never>?
    private(set) var supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics

    func prewarm() {
        guard supportsHaptics, engine == nil else { return }
        do {
            let e = try CHHapticEngine()
            e.playsHapticsOnly = true
            // Restart through the engine itself, not through `self`: CoreHaptics
            // invokes this off the main actor, so it must not touch isolated state.
            e.resetHandler = { [weak e] in try? e?.start() }
            e.stoppedHandler = { _ in }
            try e.start()
            engine = e
        } catch {
            supportsHaptics = false
        }
    }

    /// Plays the AHAP asset for a pattern, looping per cycle count.
    func play(_ pattern: BreathPattern) throws {
        guard supportsHaptics else { return }
        // Cancel the outgoing pattern's stop timer before the new player exists,
        // so it can never fire against this pattern.
        stopTask?.cancel()
        if engine == nil {
            prewarm()
        }
        guard let engine, let url = Bundle.main.url(forResource: pattern.hapticAssetName, withExtension: "ahap") else { return }
        let data = try Data(contentsOf: url)
        let hapticPattern = try CHHapticPattern(dictionary: JSONSerialization.jsonObject(with: data) as? [CHHapticPattern.Key: Any] ?? [:])
        let p = try engine.makeAdvancedPlayer(with: hapticPattern)
        p.loopEnabled = pattern.cycles > 1
        p.loopEnd = pattern.cycleDuration
        try p.start(atTime: CHHapticTimeImmediate)
        player = p
        // Stop after the full duration; the view also stops on cancel.
        stopTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(pattern.totalDuration))
            guard !Task.isCancelled else { return }
            self?.stop()
        }
    }

    func stop() {
        stopTask?.cancel()
        stopTask = nil
        try? player?.stop(atTime: CHHapticTimeImmediate)
        player = nil
    }
}
