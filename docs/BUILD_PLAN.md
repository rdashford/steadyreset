**BUILD PLAN**

**Steady Reset**

*How Robert and Claude build the app specified in PRD v4 — working
model, architecture decisions, session-by-session work breakdown, and
gates.*

**Version:** v1

**Date:** September 16, 2026

**Owner:** Robert Ashford, PhD, MSW

**Companion documents:** Steady_Reset_PRD_v4.docx; prototype skeleton
(SteadyReset_skeleton_v1.zip)

**Contents**

**1. How We Work**

There is no engineering team. Robert owns the product, makes decisions,
tests on real devices, and handles everything that requires a human or
an account (Apple Developer Program, App Store Connect, clinician
review, counsel, trademark filing). Claude does the engineering. That
split determines the tooling.

**1.1 Two surfaces, two jobs**

| **Surface**                                                             | **Used for**                                                                                                                                          | **Why**                                                                                                                                                            |
|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| This chat (Claude app)                                                  | Planning, the PRD and this plan, copy and scripts, clinical content drafts, App Store text, research protocol, decisions                              | Best place to think and decide; produces documents; keeps memory of the project                                                                                    |
| Claude Code Desktop on Robert's Mac (or Claude Code inside Xcode 26.3+) | All code: writing Swift, generating the Xcode project, building, running unit tests, driving the iOS Simulator, reading crash logs, committing to git | It can compile and run the app; this chat cannot. Claude Code Desktop opens the iOS Simulator in a pane and can build, launch, tap through, and screenshot the app |
| Robert's hands                                                          | On-device testing (haptics, Action Button, Watch, HealthKit, Live Activities, notifications), TestFlight distribution, everything behind an Apple ID  | None of these work in the Simulator or without an account                                                                                                          |

**1.2 The session ritual (applies in both surfaces)**

1.  Open by stating: which session from Section 5 is being executed,
    what is already done, what this session will produce, and what
    Robert will need to do or test afterward.

2.  Robert signs off or adjusts. Nothing substantive happens before
    that.

3.  Claude does the work. In Claude Code: write, build, run tests, run
    in Simulator, fix, commit with the session ID in the message.

4.  Close by stating what was done, what is unverified until device
    testing, and the exact steps Robert should perform on device (with
    what to look for).

5.  Robert tests, reports back in the next session's opening. Bugs found
    become the first item of the next session.

**1.3 Git and housekeeping**

- One repository (GitHub, private). \`main\` is always buildable. Each
  session works on a branch named for its ID (\`s0-1-compile\`) and
  merges when its done-when criteria pass.

- The PRD and this plan live in \`docs/\`. Decisions that change the PRD
  are made in chat and the PRD is revised there (v5, v6…), then copied
  into the repo.

- \`CLAUDE.md\` in the repo carries the non-negotiable product rules so
  every Claude Code session starts with them.

**1.4 Robert's time**

The plan assumes Robert can give roughly 8–12 hours a week: two or three
Claude Code sessions of one to two hours, one chat session for decisions
and content, and device testing in between. If that changes, dates move;
scope does not.

**2. Prerequisites (before Session 0.1)**

| **Item**                                                                                           | **Who**                                | **Notes**                                                                              |
|----------------------------------------------------------------------------------------------------|----------------------------------------|----------------------------------------------------------------------------------------|
| Mac with Apple silicon, current macOS, Xcode 26 or later installed and launched once               | Robert                                 | Xcode 26.3+ can host Claude Code directly                                              |
| Claude Code Desktop installed; signed in                                                           | Robert                                 | Confirm the iOS Simulator pane opens on a sample project                               |
| Homebrew, \`xcodegen\`, \`git\`                                                                    | Robert (Claude can script it)          | XcodeGen generates the project from \`project.yml\`; the .pbxproj is never hand-edited |
| Apple Developer Program membership (organization or individual)                                    | Robert                                 | Needed for HealthKit, CloudKit, Live Activities, TestFlight, device installs           |
| Devices: iPhone 15 Pro or later (Action Button), Apple Watch (Series 9 or later)                   | Robert                                 | Haptics and most entry surfaces cannot be tested in the Simulator                      |
| Private GitHub repository                                                                          | Robert creates; Claude pushes skeleton |                                                                                        |
| Bundle ID and iCloud container decided (skeleton uses app.steadyreset)                             | Robert                                 | Change once, before first device build                                                 |
| Trademark clearance and ITU filing for STEADY RESET; domain                                        | Robert + counsel                       | Runs in parallel; does not block code                                                  |
| Contract clinician identified for content review                                                   | Robert                                 | Needed by end of Phase 1                                                               |
| Cloud accounts for Plus (deferred to Phase 2): LLM API key, TTS provider, small host for the proxy | Robert                                 | Anthropic API for the companion; TTS provider to be chosen in Session 2.1              |

**3. Architecture Decisions**

Recorded here so neither of us relitigates them mid-build. Each can be
reopened in chat with a stated reason.

| **\#** | **Decision**                                                                                                                                                                   | **Rationale**                                                                                                                                                |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AD-1   | Three Xcode targets (iPhone app, Watch app, widget/control extension) plus one shared Swift package \`SteadyCore\`; project generated by XcodeGen                              | Shared logic is testable with \`swift test\` in seconds; XcodeGen avoids the .pbxproj merge and corruption problem that AI-assisted iOS work hits constantly |
| AD-2   | SwiftUI everywhere; Swift 6 strict concurrency from day one                                                                                                                    | Retrofitting concurrency is worse than starting with it                                                                                                      |
| AD-3   | SwiftData for persistence; models in SteadyCore; iCloud sync via private CloudKit database, opt-in                                                                             | Native, no third-party dependency, CloudKit sync built in                                                                                                    |
| AD-4   | Breathing timing is a pure value type (\`BreathPattern\`) that drives haptics, voice, Watch, and UI from one timeline                                                          | One source of truth for the ±100 ms requirement; testable without a device                                                                                   |
| AD-5   | Haptics as AHAP assets played by Core Haptics on iPhone; WKInterfaceDevice haptics on Watch                                                                                    | AHAP is data, tunable without code changes; Watch has no Core Haptics                                                                                        |
| AD-6   | All notifications route through \`NotificationBudget\`; no direct scheduling anywhere                                                                                          | Enforces K15 structurally                                                                                                                                    |
| AD-7   | HealthKit is the only biosignal source; values never leave the device; only derived text (load line) may be shown or, with consent, discussed                                  | Privacy label stays clean; one integration covers every wearable                                                                                             |
| AD-8   | Partner pairing on CloudKit \`CKShare\` with three record types; no backend                                                                                                    | Robert's decision; zero server to run                                                                                                                        |
| AD-9   | Plus cloud features go through a minimal backend proxy (App Attest, StoreKit entitlement, rate limits); the client never holds an API key                                      | Free tier has no route to inference; keys stay off devices                                                                                                   |
| AD-10  | Companion text via Anthropic API through the proxy; on-device Foundation Models for summaries and rewrites; on-device-only mode falls back to Foundation Models for everything | PRD 10.3; evaluate on-device quality in Session 2.2                                                                                                          |
| AD-11  | Fixed voice lines pre-rendered at build time and bundled; user text rendered by cloud TTS at approval time; \`AVSpeechSynthesizer\` fallback in on-device-only mode            | No synthesis on the critical path                                                                                                                            |
| AD-12  | Append-only \`Event\` log with \`schemaVersion\` alongside summary models; export format defined in Phase 1                                                                    | Research readiness without refactor (PRD 15.1)                                                                                                               |
| AD-13  | Minimum iOS 26 / watchOS 26                                                                                                                                                    | Current-minus-one at fall 2026 launch; unlocks Foundation Models and current WidgetKit controls                                                              |
| AD-14  | The SwiftData \`ModelContainer\` comes off the launch path *before* E1 is measured: session 0.6's persistence-spine work is pulled forward ahead of 0.2 (decided 2026-09-22)    | Found in 0.1: \`.modelContainer\` is applied to the \`WindowGroup\` scene, so SwiftUI builds it synchronously before the first frame and before haptic prewarm — a live breach of rule 1 and E1. Measuring E1 first would benchmark an architecture we intend to replace, and force a second Instruments pass on device |

**4. Repository Layout**

| **Path**                          | **Contents**                                                                                                                                                                         |
|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Packages/SteadyCore/              | Models, technique timing, EMA scheduler, baselines, notification budget, tests. Pure Swift; no UIKit                                                                                 |
| App/SteadyReset/                  | iPhone app: entry, Router, Intents, Haptics, Views (one folder per flow as they are built), Services (HealthKit, Notifications, CloudKit, Live Activities, Speech, Companion client) |
| App/SteadyResetWatch/             | Watch app                                                                                                                                                                            |
| App/SteadyResetWidgets/           | Widgets, Control Center control, Live Activity UI                                                                                                                                    |
| Backend/ (Phase 2)                | Proxy for Plus: attestation, entitlement, rate limit, Anthropic and TTS calls. Small TypeScript service                                                                              |
| docs/                             | PRD, this plan, data dictionary, clinician review log, red-team suite                                                                                                                |
| project.yml, CLAUDE.md, README.md | Project generator spec, Claude Code rules, setup                                                                                                                                     |

**5. Work Breakdown by Session**

A session is one focused Claude Code (or chat) sitting of one to three
hours. Each row names the PRD requirements it delivers, what 'done'
means, and what Robert tests on device afterward. Sessions within a
phase are ordered by dependency; some can be swapped. Estimates are
counts of sessions, not calendar time.

**Phase 0 — Foundations (≈ 8 sessions)**

Goal: everything risky is proven on a real device before any feature
work. Exit: ≤ 2 s to first haptic on iPhone and ≤ 2.5 s on Watch;
SteadyCore tests green; clinician engaged.

| **ID** | **Session**                                                                                                                                                                          | **PRD**     | **Done when**                                                              | **Robert tests**                                                                                 |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| 0.1    | Compile the skeleton: fix API drift, \`swift test\` green, project generates, app and Watch run in Simulator                                                                         | —           | All targets build; 14 tests pass; committed to \`main\`                    | Nothing yet                                                                                      |
| 0.2    | Device signing and first install; Action Button → Steady shortcut; measure launch-to-first-haptic in Instruments; trim launch path                                                   | E1          | ≤ 2.0 s p95 over 20 cold launches                                          | Press the Action Button mid-conversation; does the sigh land before you could have typed a word? |
| 0.3    | Haptic tuning: sigh and paced AHAP curves against BreathPattern timeline; drift check; Reduce Motion path                                                                            | D1, D2, D7  | Timeline drift ≤ 100 ms over 5 min; patterns feel like breath, not buzz    | Run full Stage 2 phone-in-pocket; can you follow it without looking?                             |
| 0.4    | Watch: complication, wrist-only Stage 2, haptic vocabulary, launch timing                                                                                                            | E5          | ≤ 2.5 s complication tap to first haptic                                   | Same test on the wrist; is it discreet enough for a live argument?                               |
| 0.5    | Voice pipeline spike: choose TTS provider, render the fixed Stage 2 lines, bundle, play with ducking; AVSpeechSynthesizer fallback                                                   | C7, AD-11   | Voice lines play offline in sync with haptics                              | Does the voice sound like the brand (unhurried, plain)?                                          |
| 0.6    | Persistence spine: ModelContainer off the launch path; Session and Event written at end of a reset; history list                                                                     | 12.3, AD-12 | A completed reset appears in history after relaunch; launch time unchanged | Do three resets; check history                                                                   |
| 0.7    | Chat session: clinical content package v1 (technique scripts, feeling words, safety copy, EMA items, break script and repair templates) ready for clinician review; brand copy guide | 4, A, B, C  | Documents in docs/; clinician review scheduled                             | Read-through; approve for review                                                                 |
| 0.8    | On-device model spike: Foundation Models for one-line summaries and a rewrite; quality notes for AD-10                                                                               | 10.5        | Decision recorded: what runs on device at launch                           | Judge samples in chat                                                                            |

**Execution order (AD-14, decided 2026-09-22): run 0.6 before 0.2.** Session
IDs are unchanged — only the order is. Session 0.1 found that
\`.modelContainer\` is built synchronously during the first scene evaluation,
before the first frame and before haptic prewarm, so the launch path 0.2
measures is not the one we intend to ship. Take 0.6's "ModelContainer off the
launch path" first, then measure E1 once. The rest of 0.6 (Session/Event
written at end of a reset, history list) may stay in its original slot if
splitting it keeps the sitting short; 0.6's own "launch time unchanged"
criterion becomes "launch time measured" once 0.2 follows it.

**Phase 1 — Alpha: the core loop on both devices (≈ 16 sessions)**

Goal: Flows A, C, D, H work end to end on iPhone and Watch, with safety
routing and HealthKit baselines. Exit: Robert and up to 25 TestFlight
testers use it in real moments; return completion ≥ 60%; no
launch-blocking defects; clinician sign-off on content v1.

| **ID** | **Session**                                                                                                                                                                 | **PRD**     | **Done when**                                                 | **Robert tests**                                             |
|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|---------------------------------------------------------------|--------------------------------------------------------------|
| 1.1    | Flow A complete: Stage 3 (hot rating, word grid, third-person prompt with on-device speech), Stage 4 (reframe/intention cards, secure base), Stage 5 decisions; persistence | N1–N5       | Full reset persists all fields                                | Three real resets; does anything require thinking too early? |
| 1.2    | Alternate techniques: cold water, movement, orienting, sound; safety gates; visible alternate button                                                                        | D4, D5      | Each completes one line at a time; gates persist              | Try cold water flow at a sink                                |
| 1.3    | Plan model and onboarding part 1: 60-second first reset, technique choice, alternate, template-based break script, reframes, intention                                      | K6, Flow D  | Onboarding ≤ 5 min in Simulator run-through                   | Fresh install; time it                                       |
| 1.4    | Onboarding part 2: entry-surface setup with deep links, safety check (never stored), 988/DV resources reachable everywhere                                                  | P3, 14      | Resources in two taps from every screen                       | Verify safety check answer is not persisted                  |
| 1.5    | Flow C part 1: break announcement with 'Show them' card, sms: hand-off, return time, 20-min default with shorten note                                                       | R1, R2      | Break cannot start without return time                        | Announce a break to a willing partner                        |
| 1.6    | Flow C part 2: Live Activity + Dynamic Island timer, 8-hour fallback, state survives termination                                                                            | R3, E7      | Timer visible on Lock Screen after force-quit and restart     | Force-quit mid-break; check Lock Screen                      |
| 1.7    | NotificationBudget service + mid-break check-in + return prompt + extensions                                                                                                | R4, R5, K15 | Return prompt fires at time; extension logged                 | Take a 20-min break; watch prompts                           |
| 1.8    | 'Break' Focus: guided creation, toggle on/off via App Intents                                                                                                               | R6          | Focus turns on at break start and off at return               | Configure once; verify partner thread quiets                 |
| 1.9    | Flow H: EMA scheduler service, notification → check-in screen, Watch check-in with Digital Crown, rolling 7-day scheduling                                                  | K1, K2      | Prompts arrive in windows; expire at 20 min; ≤ 25 s to answer | Live with it for a week                                      |
| 1.10   | HealthKit read + background delivery; baseline computation; load line shown after check-in answers                                                                          | K3, K4, 11  | Load line appears for a user with Oura/Watch data             | Connect your wearable; compare load line with how you feel   |
| 1.11   | Watch live HR during reset (workout session), before/after HR saved; suggestion rule with rate limit                                                                        | D6, E6      | HR number on screen; suggestion fires at most twice/day       | Reset on wrist; check HR captured                            |
| 1.12   | History and weekly view: plain-language summaries, no scores                                                                                                                | K8          | Week view renders from real data                              | Read your own week                                           |
| 1.13   | Watch–iPhone reconciliation via WatchConnectivity                                                                                                                           | K16         | No duplicate sessions in cross-device test                    | Start on Watch, finish on phone                              |
| 1.14   | Accessibility pass 1: VoiceOver, Dynamic Type max, Reduce Motion, contrast                                                                                                  | 13.2        | Every alpha flow completable with VoiceOver                   | Try a reset with VoiceOver on                                |
| 1.15   | Crisis-language detection (on-device phrase list) in all free-text; soft routing                                                                                            | K12         | Test phrases route; false positives can continue              | Enter test phrases                                           |
| 1.16   | TestFlight alpha build; tester guide; feedback capture; chat session: clinician feedback folded into content v2                                                             | 18 Phase 1  | Build on 25 devices; issues triaged                           | Recruit testers; run the debriefs                            |

**Phase 2 — Beta: Plus, companion, pairing, everything else (≈ 20
sessions)**

Goal: all Launch-scope requirements built. Exit: 300 TestFlight users;
return completion ≥ 60%; check-in compliance ≥ 55%; red-team suite
passes; accessibility audit passed; legal review complete.

| **ID** | **Session**                                                                                                                                                         | **PRD**          | **Done when**                                                         | **Robert tests**                             |
|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|-----------------------------------------------------------------------|----------------------------------------------|
| 2.1    | Backend proxy: App Attest, StoreKit 2 entitlement check, rate limits, Anthropic and TTS passthrough; deploy                                                         | AD-9, 12.2       | Unentitled device gets 403; entitled device streams a reply           | Buy Plus in sandbox; talk to it              |
| 2.2    | Companion v1: context packet, behavioral contract system prompt, streaming UI, voice input (on-device speech), on-device crisis pre-check, transcript opt-in/delete | C1, C2, C8, 10.3 | Conversation works in break (need-focused opener) and debrief         | Use it after a real disagreement             |
| 2.3    | Chat session: red-team suite (200+ prompts) drafted with pass criteria; automated judge harness in Backend/                                                         | C2               | Suite runs; failures listed                                           | Review failures; decide fixes                |
| 2.4    | Companion hardening from suite; output check for the 'never' list; clinician transcript review process                                                              | C2               | ≥ 98% automated, 100% crisis subset by hand                           | Sign off                                     |
| 2.5    | Drafting in the user's voice (scripts, reframes, intention) in onboarding and tune-up; approval flow                                                                | C4               | Drafts are editable; nothing unapproved reaches the moment            | Draft your own plan                          |
| 2.6    | Flow B: hold a message — no-send canvas, delay, urge wave, end screen, share-sheet hand-off; 'say what you mean' rewrite (Plus)                                     | R7, R8, R9       | Draft cannot be sent from app; rewrite shown beside original          | Hold a real text                             |
| 2.7    | Flow G debrief + Flow F companion at return; repaired-conversation tracking                                                                                         | K9               | Debrief links to session; ~2 h schedule with reschedule               | Debrief after a return                       |
| 2.8    | Flow I rehearsal with neutral counterpart; saves opening line and intention                                                                                         | C5               | Two-minute practice completes; artifacts saved                        | Rehearse a real upcoming conversation        |
| 2.9    | Weekly observation (on-device, question-phrased, mutable topics); tune-up flow                                                                                      | C6, K7           | One observation per week from real data                               | Read yours; is it a question, not a verdict? |
| 2.10   | Voices: Plus voice packs as on-demand resources; user-text TTS at approval time with cache; on-device-only fallback                                                 | C7, AD-11        | Switching voice re-renders plan lines; works offline afterward        | Try each voice                               |
| 2.11   | Technique personalization from hot-drop and HR-drop (Plus); technique library pages                                                                                 | D8, D9           | Default adapts after ≥ 5 sessions; override works                     | Check what it picks for you                  |
| 2.12   | Relationship profiles (multiple), tagging a reset to a profile                                                                                                      | R11              | Two profiles with distinct scripts                                    | Set up partner and a colleague               |
| 2.13   | Partner pairing on CloudKit: invite, code word, break announcements, return receipts, 'Steady yourself too', private toggle, silent unpair                          | R10, Flow J      | Receipt ≤ 30 s p95 between two devices                                | Pair with your partner; both test            |
| 2.14   | iCloud sync (opt-in), Face ID lock, export (PDF/CSV) with data dictionary                                                                                           | K10, K11, 13.3   | Export matches dictionary; Health data absent                         | Export and read it                           |
| 2.15   | Secure-base library (photo, voice note, person, memory)                                                                                                             | N5               | Items appear in Stage 4, break, Flow B                                | Record a voice note                          |
| 2.16   | StoreKit 2 subscription and lifetime tier; paywall placement rules (never in Flows A–C or a break)                                                                  | 17               | Sandbox purchase, restore, entitlement to proxy                       | Buy, cancel, restore                         |
| 2.17   | Onboarding final: wearable connection, Watch pairing, Plus preview; localization scaffolding (strings externalized)                                                 | K6, K13          | All strings in catalogs                                               | Fresh install end to end                     |
| 2.18   | Accessibility audit (formal) and fixes; Assistive Access                                                                                                            | 13.2             | Audit checklist passed                                                | Spot-check with VoiceOver                    |
| 2.19   | Privacy: App Privacy label draft, purpose strings, disclosures screen, on-device-only mode verification (no network calls when set)                                 | 13.3, 10.6       | Network log empty in on-device-only mode                              | Review with counsel                          |
| 2.20   | TestFlight beta; feedback triage; chat session: content v3 with clinician; App Store copy and screenshots plan                                                      | 18 Phase 2       | 300 testers; metrics dashboard from opt-in analytics or tester survey | Run the beta                                 |

**Phase 3 — Launch (≈ 6 sessions)**

| **ID** | **Session**                                                                                                                  | **PRD**     | **Done when**                                        | **Robert tests**                         |
|--------|------------------------------------------------------------------------------------------------------------------------------|-------------|------------------------------------------------------|------------------------------------------|
| 3.1    | Beta defect burn-down; performance and battery verification on device                                                        | 13.1        | All launch gates in PRD 16 met or consciously waived | Final device pass                        |
| 3.2    | Research readiness verification: event log completeness, export against data dictionary, consent flag path (hidden)          | 15.1, AD-12 | Export of a test account validates                   | None                                     |
| 3.3    | App Store: metadata, screenshots (Simulator-driven), privacy label, review notes explaining HealthKit and AI use, 17+ rating | 14          | Submitted                                            | Approve copy                             |
| 3.4    | Backend hardening: monitoring, alerts, cost caps, key rotation                                                               | AD-9        | Alerts fire in a drill                               | None                                     |
| 3.5    | Review response and fixes; phased release settings                                                                           | —           | Approved                                             | Watch the review                         |
| 3.6    | Launch day checklist; support inbox; first-week metrics review in chat                                                       | 16          | Live                                                 | Celebrate briefly; then read the numbers |

**Post-launch (not scheduled)**

- Spanish localization; outcomes study protocol and consent flow with
  Robert's university relationship; Android partner pairing (needs
  backend); technique additions from study data.

**6. Timeline**

About 50 sessions. At two to three sessions a week plus device testing
between them, that is roughly six to seven months to submission — longer
than the 23-week team plan in PRD Section 18, because one builder and
one tester cannot parallelize. The PRD's Section 18 should be revised to
match once Phase 0 timing is confirmed.

| **Phase**       | **Sessions** | **Calendar (at 2–3 sessions/week)** |
|-----------------|--------------|-------------------------------------|
| 0\. Foundations | 8            | Weeks 1–4                           |
| 1\. Alpha       | 16           | Weeks 5–12                          |
| 2\. Beta        | 20           | Weeks 13–22                         |
| 3\. Launch      | 6            | Weeks 23–27, including App Review   |

External gates that can hold the line regardless of build pace:
clinician review (end of Phase 1 and Phase 2), counsel review of privacy
and terms (Phase 2), trademark clearance (any time before public
announcement), App Review (Phase 3).

**7. Testing Strategy for a Two-Person Build**

- **Unit tests in SteadyCore** run in seconds and gate every commit:
  timing, scheduling, baselines, budget, export format.

- **Simulator runs** in Claude Code for every UI change: launch flows,
  tap through, screenshot, check VoiceOver labels. Haptics, HealthKit
  background delivery, Live Activities on the Lock Screen, Action
  Button, and Watch pairing do not work there.

- **Device scripts** for Robert: each session ends with a short numbered
  script of what to do and what to look for. Findings go into the next
  session's opening.

- **Real-moment testing** is the only test that matters for Stage 2.
  Robert and the alpha testers use it in real friction, then debrief;
  five to eight moderated debriefs per phase.

- **Red-team suite** for the companion runs automatically against the
  proxy; the crisis subset is always reviewed by a human.

- **TestFlight** alpha (25) and beta (300) with a tester guide and a
  two-question survey after each real use.

**8. Risks Specific to This Build Model**

| **Risk**                                                                     | **Mitigation**                                                                                                                          |
|------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Claude cannot feel haptics or hear voice; tuning depends on Robert's reports | Session 0.3 and 0.5 are iterative; Robert describes in concrete terms (too sharp, too short, lags the voice); AHAP changes need no code |
| Xcode project drift or corruption from AI edits                              | XcodeGen only; .pbxproj is generated and gitignored-safe; CLAUDE.md forbids hand edits                                                  |
| API drift between Claude's training and iOS 26/27 SDKs                       | Session 0.1 exists for this; Claude Code reads SDK headers and compiler errors; keep Apple docs links in CLAUDE.md                      |
| Single point of failure on Robert's time                                     | Sessions are small and independent enough to pause; \`main\` is always shippable                                                        |
| Cloud costs for Plus before revenue                                          | Proxy has hard daily caps and alerts from Session 2.1; free tier never calls                                                            |
| App Review pushback on health or AI language                                 | Review notes drafted in 3.3 explain HealthKit use, wellness framing, and AI disclosure; wording pre-checked by counsel                  |
| Scope creep in chat                                                          | Changes go into the PRD as a new version first; the build follows the PRD, not the conversation                                         |

**9. Next Step**

Session 0.1 in Claude Code Desktop: open the unzipped skeleton as the
project folder and ask Claude to make it compile, run \`swift test\`,
generate the project, and launch on the iPhone and Watch simulators. The
README lists the prerequisites.
