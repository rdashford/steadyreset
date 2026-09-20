# Steady Reset — guidance for Claude Code

This repo is a two-person build: Robert (product owner, decisions, testing on device) and Claude (engineering).
The product spec is `docs/Steady_Reset_PRD_v4.docx` (convert with `pandoc -t markdown` if you need text). Requirement IDs (E1, D4, R6, K15…) are referenced in code comments; keep that convention.

## Platform
- iOS 26+ / watchOS 26+, Swift 6 (strict concurrency), SwiftUI, SwiftData, App Intents, WidgetKit, ActivityKit, Core Haptics, HealthKit, CloudKit.
- Project is generated with XcodeGen from `project.yml`. **Never edit the .pbxproj by hand.** Add files to the right folder, then `xcodegen generate`.
- Shared logic lives in `Packages/SteadyCore` (pure Swift + SwiftData models). UI lives in `App/`.

## Build & test
- `cd Packages/SteadyCore && swift test` — fast unit tests for timing, EMA, baselines, budget. Run before every commit.
- Keep this repo on a local disk (`~/github/SteadyReset`), never in iCloud Drive or another synced folder. iCloud stamps `com.apple.FinderInfo` on the in-repo `.build`, and `codesign` then refuses to sign the test bundle ("resource fork, Finder information, or similar detritus not allowed"), which breaks `swift test` outright.
- `xcodegen generate && xcodebuild -scheme SteadyReset -destination 'platform=iOS Simulator,name=iPhone 18 Pro' build`
- Watch: `-scheme SteadyResetWatch -destination 'platform=watchOS Simulator,name=Apple Watch Series 12 (46mm)'`
- Simulator device names track the installed Xcode (currently 27, with iOS/watchOS 27 runtimes). Check `xcrun simctl list devices available` before assuming a name; the deployment target stays iOS 26 / watchOS 26 regardless.
- Haptics do not run in the Simulator; verify on device. The ≤2 s launch budget (E1) is measured in Instruments on device.

## Non-negotiable product rules (from the PRD)
1. Nothing in Stages 1–2 (interrupt, down-regulate) may depend on network, SwiftData load, or a model call. Haptics first.
2. No reading or deciding while flooded: one instruction per screen, ≥34 pt, tap targets ≥60 pt, no sliders, no hidden gestures.
3. A break cannot start without a return time. Default 20 min.
4. Biosignal values never leave the device. No population norms; personal medians only. Never label a state ("you're anxious").
5. The app never sends a message itself; hand off to Messages.
6. No inference in the free tier; entitlement is checked server-side.
7. Crisis-language check runs on device before any text goes to a cloud model.
8. Notifications go through `NotificationBudget`; nothing schedules directly.
9. Copy: second person, present tense, short. No exclamation points, streaks, badges, or diagnostic words.

## Conventions
- One type per file once files grow; `// MARK:` by reset stage.
- Prefer value types in SteadyCore; `@Model` classes only for persistence.
- Every public function in SteadyCore gets a Swift Testing test.
- Log with `os.Logger(subsystem: "app.steadyreset", category: …)`; never log user text or health values.

## Agents, skills, hooks (in .claude/)
- Subagents in `.claude/agents/`: xcode-builder (build/test, failures only), swift-reviewer (read-only review, has project memory), prd-compliance-checker (maps code to PRD IDs), ui-designer (flooded-user UI rules), accessibility-auditor, qa-tester (may edit tests only), copy-editor (brand voice), privacy-auditor (rules 1/4/6/7), clinical-content-reviewer (prepares content for the licensed clinician).
- Standard loop for any feature: implement → @xcode-builder → fix → @swift-reviewer + @prd-compliance-checker + @ui-designer in parallel → fix → @qa-tester → @xcode-builder → commit. Before TestFlight: @accessibility-auditor + @privacy-auditor + @copy-editor.
- Skills: /session-open, /device-test-script, /prd <ID>.
- Hooks block edits to the generated .xcodeproj, secrets, and the PRD; format Swift on save; print the ritual at start.
- Agent teams are off by default (settings.json). Turn on only for the two recipes in docs/CLAUDE_CODE_SETUP.md (parallel diff review, competing-hypothesis debugging), then turn off.

## Session ritual
Start each session by reading `docs/BUILD_PLAN.md`, stating which session you are executing, what is done, and what you will do, and wait for Robert's sign-off before substantive work.
