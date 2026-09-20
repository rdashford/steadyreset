import SwiftUI
import SteadyCore

/// Flow A skeleton. Stage 2 starts immediately; no question comes first (PRD 5.2, 5.3).
struct ResetView: View {
    let entrySurface: EntrySurface
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stage: ResetStage = .downRegulate
    @State private var phaseCue: String = ""
    @State private var scale: CGFloat = 0.6
    @State private var hotBefore: Int?
    @State private var hotAfter: Int?
    @State private var words: Set<String> = []
    private let sequence = DefaultDownRegulation()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // D3: dark by default; the phone should not light the room.
            switch stage {
            case .interrupt, .downRegulate: downRegulate
            case .name: nameStage
            case .reorient: reorientStage
            case .returnStage: returnStage
            }
        }
        .preferredColorScheme(.dark)
        .task { await runDownRegulation() }
        .onDisappear { HapticEngine.shared.stop(); UIApplication.shared.isIdleTimerDisabled = false }
    }

    // MARK: Stage 2
    private var downRegulate: some View {
        VStack {
            Spacer()
            Circle()
                .fill(.white.opacity(0.9))
                .frame(width: 220, height: 220)
                .scaleEffect(reduceMotion ? 1.0 : scale)
                .opacity(reduceMotion ? Double(scale) : 1.0)
            Text(phaseCue).font(.system(size: 34, weight: .medium)).foregroundStyle(.white).padding(.top, 40)
            Spacer()
            // D4: the user's alternate is one visible button. No hidden gestures.
            Button("Cold water instead") { /* route to alternate technique (to build) */ }
                .font(.title3).foregroundStyle(.white.opacity(0.7)).padding(.bottom, 32)
        }
    }

    private func runDownRegulation() async {
        UIApplication.shared.isIdleTimerDisabled = true
        for pattern in [sequence.sigh, sequence.paced] {
            try? HapticEngine.shared.play(pattern)
            for (offset, phase) in pattern.timeline() {
                _ = offset
                await MainActor.run {
                    phaseCue = phase.cue
                    withAnimation(.easeInOut(duration: phase.seconds)) {
                        scale = (phase.kind == .exhale) ? 0.6 : 1.0
                    }
                }
                try? await Task.sleep(for: .seconds(phase.seconds))
                if Task.isCancelled { return }
            }
        }
        await MainActor.run { stage = .name }
    }

    // MARK: Stage 3
    private var nameStage: some View {
        VStack(spacing: 28) {
            Text("How hot, 1 to 10?").font(.title).foregroundStyle(.white)
            HotRating(value: hotBefore == nil ? $hotBefore : $hotAfter)
            if hotBefore != nil {
                Text("One or two words.").font(.title2).foregroundStyle(.white.opacity(0.8))
                FeelingWordGrid(selection: $words)
                Button("Next") { stage = .reorient }.buttonStyle(.borderedProminent).disabled(words.isEmpty)
            }
        }.padding()
    }

    // MARK: Stage 4
    private var reorientStage: some View {
        VStack(spacing: 24) {
            Text("“I can be right later. Right now I want to be steady.”") // placeholder: user's approved reframe
                .font(.title2).foregroundStyle(.white).multilineTextAlignment(.center)
            Button("Next") { stage = .returnStage }.buttonStyle(.borderedProminent)
        }.padding()
    }

    // MARK: Stage 5
    private var returnStage: some View {
        VStack(spacing: 16) {
            Button("Go back to it") { router.route = .home }
            Button("Take a break") { router.route = .startBreak }
            Button("I'm okay") { router.route = .home }
        }.buttonStyle(.bordered).font(.title2)
    }
}

/// N1: ten large tap targets, never a slider.
struct HotRating: View {
    @Binding var value: Int?
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
            ForEach(1...10, id: \.self) { n in
                Button { value = n } label: {
                    Text("\(n)").font(.title).frame(maxWidth: .infinity, minHeight: 64)
                }
                .buttonStyle(.bordered).tint(value == n ? .white : .gray)
            }
        }
    }
}

/// N2: 8–10 granular words; max two; no keyboard. Starter set from Appendix A.7.
struct FeelingWordGrid: View {
    @Binding var selection: Set<String>
    private let words = ["hurt", "unseen", "scared", "ashamed", "trapped", "furious", "abandoned", "overwhelmed", "numb", "on edge"]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(words, id: \.self) { w in
                Button {
                    if selection.contains(w) { selection.remove(w) } else if selection.count < 2 { selection.insert(w) }
                } label: { Text(w).font(.title3).frame(maxWidth: .infinity, minHeight: 52) }
                .buttonStyle(.bordered).tint(selection.contains(w) ? .white : .gray)
            }
        }
    }
}
