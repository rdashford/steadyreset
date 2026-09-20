/// A destination inside the app.
///
/// Lives in SteadyCore rather than in the app target because the App Intents in
/// `App/SteadyReset/Intents` are compiled into both the app and the widget
/// extension (E2/E3: widgets and the Control Center control invoke
/// `StartResetIntent` directly). It was previously nested in `Router`, declared
/// in `SteadyResetApp.swift`, which is not among the extension's sources — so
/// the extension could not name it. SteadyCore is the right home rather than the
/// shared Intents folder because the Watch app will want it too. `Router`, being
/// observable app state, stays in the app.
///
/// Add `Codable` before routing this across a process boundary (app group, URL,
/// `NSUserActivity`); today `IntentBridge` works only because `openAppWhenRun`
/// runs `perform()` in the app process.
public enum Route: Equatable, Sendable {
    case home
    case reset(EntrySurface)
    case holdMessage
    case startBreak
}
