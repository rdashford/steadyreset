import WidgetKit
import SwiftUI
import AppIntents

/// E2/E3: launch widgets and a Control Center control. No timeline content in v1.
struct SteadyLaunchWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "SteadyLaunch", provider: StaticProvider()) { _ in
            Button(intent: StartResetIntent()) {
                Label("Steady", systemImage: "wind").font(.headline)
            }
            .containerBackground(.black, for: .widget)
        }
        .configurationDisplayName("Steady")
        .description("Start a reset.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .systemSmall])
    }
}

struct SteadyControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "SteadyControl") {
            ControlWidgetButton(action: StartResetIntent()) { Label("Steady", systemImage: "wind") }
        }
        .displayName("Steady Reset")
    }
}

struct StaticProvider: TimelineProvider {
    struct Entry: TimelineEntry { let date: Date }
    func placeholder(in: Context) -> Entry { .init(date: .now) }
    func getSnapshot(in: Context, completion: @escaping (Entry) -> Void) { completion(.init(date: .now)) }
    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>) -> Void) { completion(.init(entries: [.init(date: .now)], policy: .never)) }
}

@main
struct SteadyWidgetBundle: WidgetBundle {
    var body: some Widget { SteadyLaunchWidget(); SteadyControl() }
}
