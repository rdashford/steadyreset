# Steady Reset — prototype skeleton (v2: adds .claude agents, hooks, skills)

**Status: unverified.** This skeleton was written without a Swift toolchain. The first Claude Code session's job is to make it compile, run the SteadyCore tests, and launch on a simulator and device. Expect small API fixes (SwiftData macro details, ControlWidget syntax, watchOS haptic names).

## What's here
- `Packages/SteadyCore` — models (SwiftData), breathing-pattern timing (Appendix A), EMA scheduler (K1), personal baselines and load line (K4, 11.3), notification budget (K15), tests.
- `App/SteadyReset` — app entry, App Intents (E1/E4), Core Haptics engine with AHAP patterns (D1/D7), Flow A `ResetView` skeleton (Stages 2–5 wired, no persistence yet).
- `App/SteadyResetWatch` — wrist-only Stage 2 (E5).
- `App/SteadyResetWidgets` — Lock Screen/Home widget and Control Center control (E2/E3).
- `project.yml` — XcodeGen spec for all three targets, entitlements and purpose strings.
- `CLAUDE.md` — rules for Claude Code in this repo.
- `docs/` — PRD v4 and the build plan.

## First session (on your Mac)
1. Xcode 26 or later installed and opened once; Apple Developer Program membership; iPhone 15 Pro or later and an Apple Watch for device testing.
2. `brew install xcodegen`
3. `cd Packages/SteadyCore && swift test`
4. `cd ../.. && xcodegen generate && open SteadyReset.xcodeproj` — set your Team in Signing.
5. Run `SteadyReset` on a device. Set the Action Button to the "Steady" shortcut. Press it. You should feel the sigh pattern within 2 seconds.
