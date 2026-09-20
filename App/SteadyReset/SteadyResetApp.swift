import SwiftUI
import SwiftData
import SteadyCore

@main
struct SteadyResetApp: App {
    /// Keep the launch path lean (E1): the container is created lazily off the critical path;
    /// the reset screen must be able to start haptics before SwiftData finishes loading.
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .task { HapticEngine.shared.prewarm() }
        }
        .modelContainer(for: steadySchemaModels)
    }
}

/// Deep-link routing from App Intents, widgets, and notifications into a flow.
@Observable
final class Router {
    enum Route: Equatable { case home, reset(EntrySurface), holdMessage, startBreak }
    var route: Route = .home
}

struct RootView: View {
    @Environment(Router.self) private var router
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        content
            .onAppear(perform: consumeIntent)
            .onChange(of: scenePhase) { _, phase in if phase == .active { consumeIntent() } }
    }
    /// E1: an intent that opened the app hands its route over here; nothing renders in between.
    private func consumeIntent() {
        if let r = IntentBridge.shared.pending { router.route = r; IntentBridge.shared.pending = nil }
    }
    @ViewBuilder private var content: some View {
        switch router.route {
        case .home: HomeView()
        case .reset(let surface): ResetView(entrySurface: surface)
        case .holdMessage: Text("Hold a message — Flow B (to build)")
        case .startBreak: Text("Start a break — Flow C (to build)")
        }
    }
}

struct HomeView: View {
    @Environment(Router.self) private var router
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Button { router.route = .reset(.inApp) } label: {
                Text("Steady").font(.system(size: 44, weight: .semibold)).frame(maxWidth: .infinity).padding(.vertical, 40)
            }
            .buttonStyle(.borderedProminent)
            HStack {
                Button("Hold a message") { router.route = .holdMessage }
                Button("Start a break") { router.route = .startBreak }
            }.buttonStyle(.bordered)
            Spacer()
        }
        .padding()
    }
}
