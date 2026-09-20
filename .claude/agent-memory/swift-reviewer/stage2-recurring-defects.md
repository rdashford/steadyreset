---
name: stage2-recurring-defects
description: Recurring defect classes to check on every Stage 1-2 (haptics/breathing) change in Steady Reset
metadata:
  type: project
---

Four defect classes keep recurring on the Stage 1–2 path. Check all four on any change to `HapticEngine`, `ResetView`, `WatchResetView`, or `BreathPattern` consumers.

1. **Fire-and-forget stop timers.** Delayed `stop()` is scheduled with an unstored `Task`/`asyncAfter` and never cancelled, so a stale timer from an earlier pattern kills the pattern currently playing. Sequential play calls (sigh → paced) make this a live race, not a theoretical one.
2. **Cumulative `Task.sleep` instead of `timeline()` offsets.** Views sleep per-phase and discard the absolute `offset` from `BreathPattern.timeline()`, so visual/voice cues drift later than the absolute-time CoreHaptics track over a 90 s segment.
3. **Static `.ahap` assets assumed to match a computed `cycleDuration`.** `loopEnd = pattern.cycleDuration` only holds for the default 5.5 bpm; any user-set rate desynchronises the loop. Generating `CHHapticPattern` from `timeline()` fixes this and removes main-actor file I/O at the same time.
4. **Silent failure.** `try?` everywhere plus `supportsHaptics = false` on one transient error means a haptics-first product can degrade to nothing with no signal. Ask for an `os.Logger` line (no user text/health values) on every swallowed error.

**Why:** PRD E1 (≤2 s to first haptic) and CLAUDE.md rule 1 make haptics the load-bearing part of Stages 1–2; each of these fails silently rather than loudly.
**How to apply:** Raise as Critical when a stale timer can stop a live pattern; Should fix for drift and silent failure. See also [[launch-path-modelcontainer]].
