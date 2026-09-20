import CoreHaptics
import Foundation
import SteadyCore

/// D1/D7: haptic-led breathing. Patterns live in Resources/Haptics/*.ahap and are timed to BreathPattern.
/// Prewarmed at launch so first cue lands within the ≤2 s budget.
final class HapticEngine {
    static let shared = HapticEngine()
    private var engine: CHHapticEngine?
    private var player: CHHapticAdvancedPatternPlayer?
    private(set) var supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics

    func prewarm() {
        guard supportsHaptics, engine == nil else { return }
        do {
            let e = try CHHapticEngine()
            e.playsHapticsOnly = true
            e.resetHandler = { [weak self] in try? self?.engine?.start() }
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
        if engine == nil { prewarm() }
        guard let engine, let url = Bundle.main.url(forResource: pattern.hapticAssetName, withExtension: "ahap") else { return }
        let data = try Data(contentsOf: url)
        let hapticPattern = try CHHapticPattern(dictionary: try JSONSerialization.jsonObject(with: data) as? [CHHapticPattern.Key: Any] ?? [:])
        let p = try engine.makeAdvancedPlayer(with: hapticPattern)
        p.loopEnabled = pattern.cycles > 1
        p.loopEnd = pattern.cycleDuration
        try p.start(atTime: CHHapticTimeImmediate)
        player = p
        // Stop after the full duration; the view also stops on cancel.
        DispatchQueue.main.asyncAfter(deadline: .now() + pattern.totalDuration) { [weak self] in self?.stop() }
    }

    func stop() { try? player?.stop(atTime: CHHapticTimeImmediate); player = nil }
}
