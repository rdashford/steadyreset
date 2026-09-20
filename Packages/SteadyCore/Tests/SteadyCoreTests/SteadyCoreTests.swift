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
}

@Suite struct BaselineTests {
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
}
