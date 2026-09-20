import SwiftUI
import WatchKit
import SteadyCore

/// E5: one large control per screen. Stage 2 must complete on the wrist with haptics alone.
@main
struct SteadyResetWatchApp: App {
    var body: some Scene { WindowGroup { WatchHomeView() } }
}

struct WatchHomeView: View {
    @State private var running = false
    var body: some View {
        if running { WatchResetView(onDone: { running = false }) }
        else {
            Button { running = true } label: { Text("Steady").font(.title).frame(maxWidth: .infinity, minHeight: 120) }
                .buttonStyle(.borderedProminent)
        }
    }
}

struct WatchResetView: View {
    let onDone: () -> Void
    @State private var cue = ""
    private let sequence = DefaultDownRegulation()
    var body: some View {
        Text(cue).font(.title2).multilineTextAlignment(.center)
            .task {
                let device = WKInterfaceDevice.current()
                for pattern in [sequence.sigh, sequence.paced] {
                    for (_, phase) in pattern.timeline() {
                        cue = phase.cue
                        switch phase.kind {
                        case .inhale: device.play(.directionUp)
                        case .topOff: device.play(.click)
                        case .exhale: device.play(.directionDown)
                        case .hold: break
                        }
                        try? await Task.sleep(for: .seconds(phase.seconds))
                    }
                }
                onDone()
            }
    }
}
