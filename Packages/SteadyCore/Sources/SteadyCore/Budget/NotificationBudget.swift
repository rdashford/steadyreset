import Foundation

/// Single scheduler policy for every interruption (PRD 5.12, K15).
/// Priority: return and mid-break > biosignal suggestion (≤2/day) > EMA > tune-up. Over budget or in quiet hours → dropped, not queued.
public enum NotificationKind: Int, Sendable, Comparable, CaseIterable {
    case returnPrompt = 0, midBreakCheckIn, suggestion, emaPrompt, debrief, tuneUp
    public static func < (l: Self, r: Self) -> Bool { l.rawValue < r.rawValue }
    /// Always delivered regardless of budget (the user asked for the break; the return is the point).
    public var bypassesBudget: Bool { self == .returnPrompt || self == .midBreakCheckIn }
    public var dailyCap: Int? { self == .suggestion ? 2 : nil }
}

public struct NotificationBudget: Sendable {
    public var dailyCap: Int
    public var quietStartHour: Int
    public var quietEndHour: Int
    public var calendar: Calendar

    public init(dailyCap: Int = 4, quietStartHour: Int = 22, quietEndHour: Int = 8, calendar: Calendar = .current) {
        self.dailyCap = dailyCap; self.quietStartHour = quietStartHour; self.quietEndHour = quietEndHour; self.calendar = calendar
    }

    public func isQuiet(_ date: Date) -> Bool {
        let h = calendar.component(.hour, from: date)
        return quietStartHour > quietEndHour ? (h >= quietStartHour || h < quietEndHour) : (h >= quietStartHour && h < quietEndHour)
    }

    /// Decide whether a notification of `kind` at `date` may be delivered, given what was already delivered that day.
    public func allows(_ kind: NotificationKind, at date: Date, deliveredToday: [NotificationKind]) -> Bool {
        if kind.bypassesBudget { return true }
        if isQuiet(date) { return false }
        if let cap = kind.dailyCap, deliveredToday.filter({ $0 == kind }).count >= cap { return false }
        let counted = deliveredToday.filter { !$0.bypassesBudget }.count
        return counted < dailyCap
    }
}
