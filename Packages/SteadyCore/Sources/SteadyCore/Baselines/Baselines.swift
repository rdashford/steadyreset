import Foundation

/// Personal rolling baselines (PRD 11.3). Medians, not means; no population norms anywhere.
public struct Baseline: Sendable {
    public static func median(_ values: [Double]) -> Double? {
        let s = values.sorted()
        guard !s.isEmpty else { return nil }
        let mid = s.count / 2
        return s.count % 2 == 0 ? (s[mid - 1] + s[mid]) / 2 : s[mid]
    }

    /// Rolling median over the last `days` days of (date, value) samples ending at `asOf`.
    public static func rollingMedian(_ samples: [(Date, Double)], days: Int, asOf: Date = .now) -> Double? {
        let cutoff = asOf.addingTimeInterval(-Double(days) * 86400)
        return median(samples.filter { $0.0 >= cutoff && $0.0 <= asOf }.map(\.1))
    }

    /// Plain-language "load today" line. Deliberately coarse; never a score.
    public static func loadLine(restingHRLatest: Double?, restingHRMedian28: Double?,
                                hrvLatest: Double?, hrvMedian28: Double?,
                                sleepHoursLatest: Double?, sleepMedian28: Double?) -> String? {
        var signals = 0
        var flags: [String] = []
        if let a = restingHRLatest, let b = restingHRMedian28, a > b * 1.08 { signals += 1; flags.append("resting heart rate up") }
        if let a = hrvLatest, let b = hrvMedian28, a < b * 0.85 { signals += 1; flags.append("HRV down") }
        if let a = sleepHoursLatest, let b = sleepMedian28, a < b - 1.0 { signals += 1; flags.append("short sleep") }
        switch signals {
        case 0: return restingHRLatest == nil && hrvLatest == nil && sleepHoursLatest == nil ? nil : "Load today: about your usual."
        case 1: return "Load today: a little higher than usual (\(flags[0]))."
        default: return "Load today: higher than usual (\(flags.joined(separator: ", ")))."
        }
    }

    /// Heart-rate suggestion rule (E6): elevated over personal baseline by `margin` bpm with no motion, rate-limited by the caller.
    public static func shouldSuggestReset(currentHR: Double, restingMedian14: Double?, margin: Double, isMoving: Bool) -> Bool {
        guard !isMoving, let base = restingMedian14 else { return false }
        return currentHR >= base + margin && currentHR >= 90
    }
}
