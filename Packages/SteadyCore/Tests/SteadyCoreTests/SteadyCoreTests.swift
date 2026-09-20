import Testing
import Foundation
@testable import SteadyCore

@Suite struct TechniqueTests {
    @Test func sighTimingMatchesAppendixA() {
        let p = BreathPattern.physiologicalSigh
        #expect(p.cycles == 3)
        #expect(abs(p.cycleDuration - 10.0) < 0.001)
        #expect(abs(p.totalDuration - 30.0) < 0.001)
        #expect(p.timeline().count == 9)
    }
    @Test func pacedDefaultsToFivePointFive() {
        let p = BreathPattern.paced()
        #expect(abs(p.cycleDuration - (60.0 / 5.5)) < 0.01)
        #expect(p.phases[0].seconds < p.phases[1].seconds) // exhale longer than inhale
        #expect(abs(p.totalDuration - 90) < 6)
    }
    @Test func pacedClampsRate() {
        #expect(abs(BreathPattern.paced(breathsPerMinute: 2).cycleDuration - 60.0 / 4.5) < 0.01)
        #expect(abs(BreathPattern.paced(breathsPerMinute: 20).cycleDuration - 60.0 / 6.5) < 0.01)
    }
}

@Suite struct EMATests {
    @Test func schedulesWithinWindowsAndSpacing() {
        let s = EMAScheduler(promptsPerDay: 2)
        let times = s.schedule(days: 7, seed: 42)
        #expect(times.count == 14)
        let cal = Calendar.current
        for t in times {
            let h = cal.component(.hour, from: t)
            #expect((10..<13).contains(h) || (18..<21).contains(h))
        }
        for i in 1..<times.count where cal.isDate(times[i], inSameDayAs: times[i-1]) {
            #expect(times[i].timeIntervalSince(times[i-1]) >= 90 * 60)
        }
    }
    @Test func deterministicWithSeed() {
        let s = EMAScheduler()
        #expect(s.schedule(days: 3, seed: 7) == s.schedule(days: 3, seed: 7))
    }
    @Test func staysUnderPendingNotificationLimit() {
        #expect(EMAScheduler(promptsPerDay: 4).schedule(days: 7, seed: 1).count <= 28)
    }
    /// K1/K2: an EMA prompt expires 20 minutes after it fires, so a missed prompt dies quietly instead of nagging.
    @Test func promptExpiresTwentyMinutesAfterItFires() {
        let prompt = Date(timeIntervalSince1970: 1_789_000_000)
        #expect(EMAScheduler().expiryMinutes == 20)
        #expect(EMAScheduler().expiry(for: prompt) == prompt.addingTimeInterval(20 * 60))
        #expect(EMAScheduler(expiryMinutes: 5).expiry(for: prompt) == prompt.addingTimeInterval(5 * 60))
    }
}

@Suite struct BaselineTests {
    /// Fixed instant; `rollingMedian` is calendar-free (it subtracts `days * 86400`), so no time zone or DST enters the test.
    let asOf = Date(timeIntervalSince1970: 1_789_000_000)
    func daysBefore(_ days: Double) -> Date { asOf.addingTimeInterval(-days * 86400) }

    @Test func medianEvenOdd() {
        #expect(Baseline.median([3, 1, 2]) == 2)
        #expect(Baseline.median([4, 1, 3, 2]) == 2.5)
        #expect(Baseline.median([]) == nil)
    }
    @Test func loadLineIsCoarse() {
        let l = Baseline.loadLine(restingHRLatest: 70, restingHRMedian28: 60, hrvLatest: 30, hrvMedian28: 50, sleepHoursLatest: 7, sleepMedian28: 7)
        #expect(l?.hasPrefix("Load today: higher") == true)
        #expect(Baseline.loadLine(restingHRLatest: nil, restingHRMedian28: nil, hrvLatest: nil, hrvMedian28: nil, sleepHoursLatest: nil, sleepMedian28: nil) == nil)
    }
    @Test func suggestionNeedsBaselineAndStillness() {
        #expect(Baseline.shouldSuggestReset(currentHR: 110, restingMedian14: 62, margin: 30, isMoving: false))
        #expect(!Baseline.shouldSuggestReset(currentHR: 110, restingMedian14: 62, margin: 30, isMoving: true))
        #expect(!Baseline.shouldSuggestReset(currentHR: 110, restingMedian14: nil, margin: 30, isMoving: false))
    }
    /// K4: the rolling window is closed at both ends - only samples in [asOf - days, asOf] count.
    @Test func rollingMedianWindowIsClosedAtBothEnds() {
        // A sample exactly on the cutoff and one exactly at asOf are in; one second outside either end is out.
        let samples: [(Date, Double)] = [
            (daysBefore(14), 10),
            (daysBefore(14).addingTimeInterval(-1), 1_000),
            (asOf, 20),
            (asOf.addingTimeInterval(1), 2_000)
        ]
        #expect(Baseline.rollingMedian(samples, days: 14, asOf: asOf) == 15) // median of [10, 20] only
        #expect(Baseline.rollingMedian([(daysBefore(14), 42)], days: 14, asOf: asOf) == 42)
        #expect(Baseline.rollingMedian([(daysBefore(14).addingTimeInterval(-1), 42)], days: 14, asOf: asOf) == nil)
        #expect(Baseline.rollingMedian([(asOf.addingTimeInterval(1), 42)], days: 14, asOf: asOf) == nil)
    }
    /// K4: personal 14- and 28-day baselines are genuinely different windows over the same samples.
    @Test func rollingMedian14And28DifferOverTheSameSamples() {
        let samples: [(Date, Double)] = [
            (daysBefore(1), 60), (daysBefore(5), 62), (daysBefore(10), 64),
            (daysBefore(20), 100), (daysBefore(25), 102)
        ]
        #expect(Baseline.rollingMedian(samples, days: 14, asOf: asOf) == 62)  // [60, 62, 64]
        #expect(Baseline.rollingMedian(samples, days: 28, asOf: asOf) == 64)  // [60, 62, 64, 100, 102]
    }
    /// K4: no samples in the window means no baseline - never a fabricated or population value.
    @Test func rollingMedianIsNilWithoutSamplesInWindow() {
        #expect(Baseline.rollingMedian([], days: 14, asOf: asOf) == nil)
        #expect(Baseline.rollingMedian([(daysBefore(30), 60), (daysBefore(40), 62)], days: 14, asOf: asOf) == nil)
    }
}

@Suite struct BudgetTests {
    let cal: Calendar = { var c = Calendar(identifier: .gregorian); c.timeZone = TimeZone(identifier: "UTC")!; return c }()
    func at(_ hour: Int) -> Date { cal.date(from: DateComponents(year: 2026, month: 9, day: 16, hour: hour))! }

    @Test func returnPromptAlwaysAllowed() {
        let b = NotificationBudget(dailyCap: 1, calendar: cal)
        #expect(b.allows(.returnPrompt, at: at(23), deliveredToday: [.emaPrompt, .emaPrompt]))
    }
    @Test func quietHoursBlockEMA() {
        let b = NotificationBudget(calendar: cal)
        #expect(!b.allows(.emaPrompt, at: at(23), deliveredToday: []))
        #expect(b.allows(.emaPrompt, at: at(12), deliveredToday: []))
    }
    @Test func suggestionCappedAtTwo() {
        let b = NotificationBudget(dailyCap: 10, calendar: cal)
        #expect(!b.allows(.suggestion, at: at(12), deliveredToday: [.suggestion, .suggestion]))
    }
    @Test func dailyCapCountsOnlyBudgeted() {
        let b = NotificationBudget(dailyCap: 2, calendar: cal)
        #expect(b.allows(.emaPrompt, at: at(12), deliveredToday: [.returnPrompt, .midBreakCheckIn, .emaPrompt]))
        #expect(!b.allows(.emaPrompt, at: at(12), deliveredToday: [.emaPrompt, .debrief]))
    }
    /// K15: default quiet hours (22:00-08:00) wrap past midnight, so the small hours must count as quiet.
    @Test func quietHoursWrapAroundMidnight() {
        let b = NotificationBudget(calendar: cal)
        for hour in [22, 23, 0, 3, 7] { #expect(b.isQuiet(at(hour)), "expected \(hour):00 to be quiet") }
        for hour in [8, 12, 17, 21] { #expect(!b.isQuiet(at(hour)), "expected \(hour):00 to be awake") }
    }
    /// K15: quiet hours that do not cross midnight stay inside the day; the end hour is exclusive.
    @Test func quietHoursWithinASingleDay() {
        let b = NotificationBudget(quietStartHour: 13, quietEndHour: 16, calendar: cal)
        for hour in [13, 14, 15] { #expect(b.isQuiet(at(hour)), "expected \(hour):00 to be quiet") }
        for hour in [0, 12, 16, 23] { #expect(!b.isQuiet(at(hour)), "expected \(hour):00 to be awake") }
    }
}
