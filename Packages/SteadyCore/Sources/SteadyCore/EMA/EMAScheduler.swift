import Foundation

/// Semi-random EMA prompt times inside user windows (PRD 4.6, K1).
/// Pure and deterministic given a seed, so it is testable and reproducible.
public struct EMAScheduler: Sendable {
    public var windows: [EMAWindow]
    public var promptsPerDay: Int          // 2...4
    public var expiryMinutes: Int          // 20
    public var calendar: Calendar

    public init(windows: [EMAWindow] = EMAWindow.defaults, promptsPerDay: Int = 2, expiryMinutes: Int = 20, calendar: Calendar = .current) {
        self.windows = windows
        self.promptsPerDay = min(4, max(2, promptsPerDay))
        self.expiryMinutes = expiryMinutes
        self.calendar = calendar
    }

    /// Prompt times for `days` days starting tomorrow (today's remaining windows are handled by the caller).
    /// One prompt per window, cycling windows if promptsPerDay > windows.count; never two prompts within 90 minutes.
    public func schedule(days: Int = 7, from start: Date = .now, seed: UInt64 = UInt64(Date.now.timeIntervalSince1970)) -> [Date] {
        var rng = SplitMix64(seed: seed)
        var out: [Date] = []
        guard !windows.isEmpty else { return out }
        for d in 1...max(1, days) {
            guard let day = calendar.date(byAdding: .day, value: d, to: calendar.startOfDay(for: start)) else { continue }
            var dayTimes: [Date] = []
            for i in 0..<promptsPerDay {
                let w = windows[i % windows.count]
                let startMin = w.startHour * 60
                let endMin = w.endHour * 60
                guard endMin > startMin + 15 else { continue }
                var attempts = 0
                repeat {
                    let minute = startMin + Int(rng.next() % UInt64(endMin - startMin))
                    if let t = calendar.date(bySettingHour: minute / 60, minute: minute % 60, second: 0, of: day),
                       dayTimes.allSatisfy({ abs($0.timeIntervalSince(t)) >= 90 * 60 }) {
                        dayTimes.append(t); break
                    }
                    attempts += 1
                } while attempts < 20
            }
            out.append(contentsOf: dayTimes.sorted())
        }
        return out
    }

    public func expiry(for prompt: Date) -> Date { prompt.addingTimeInterval(Double(expiryMinutes) * 60) }
}

/// Small deterministic RNG for reproducible schedules in tests.
public struct SplitMix64: Sendable {
    private var state: UInt64
    public init(seed: UInt64) { state = seed }
    public mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
