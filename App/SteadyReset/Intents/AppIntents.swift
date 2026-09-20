import AppIntents
import SteadyCore

/// E1/E4: entry points that open the app straight into a flow. No intermediate screen.
struct StartResetIntent: AppIntent {
    static let title: LocalizedStringResource = "Steady"
    static let description = IntentDescription("Start a reset right now.")
    static let openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        IntentBridge.shared.pending = .reset(.actionButton)
        return .result()
    }
}

struct StartBreakIntent: AppIntent {
    static let title: LocalizedStringResource = "Start a break"
    static let openAppWhenRun = true
    @MainActor func perform() async throws -> some IntentResult {
        IntentBridge.shared.pending = .startBreak
        return .result()
    }
}

struct HoldMessageIntent: AppIntent {
    static let title: LocalizedStringResource = "Hold a message"
    static let openAppWhenRun = true
    @MainActor func perform() async throws -> some IntentResult {
        IntentBridge.shared.pending = .holdMessage
        return .result()
    }
}

struct SteadyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartResetIntent(), phrases: [
            // Every AppShortcut phrase must interpolate the app name, or the build
            // fails validation. "\(.applicationName)" alone still speaks as
            // "Steady Reset", so the bare utterance is preserved.
            "\(.applicationName)", "I need to steady in \(.applicationName)", "Start a reset in \(.applicationName)",
        ], shortTitle: "Steady", systemImageName: "wind")
        AppShortcut(intent: StartBreakIntent(), phrases: ["Start a break in \(.applicationName)"], shortTitle: "Break", systemImageName: "pause.circle")
        AppShortcut(intent: HoldMessageIntent(), phrases: ["Hold a message in \(.applicationName)"], shortTitle: "Hold", systemImageName: "envelope.badge.clock")
    }
}

/// Hands the intent's requested route to the running app. RootView reads `pending` on appear/scenePhase.
@MainActor
@Observable
final class IntentBridge {
    static let shared = IntentBridge()
    var pending: Route?
}
