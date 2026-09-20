---
name: device-test-script
description: Produce Robert's numbered on-device test script at the end of a session — what to do, what to look for, what "pass" means — covering only what the Simulator cannot verify (haptics, Action Button, Watch, HealthKit, Live Activities, notifications). Use when closing a session or when Robert types /device-test-script.
---

Write to `docs/device-tests/<session-id>.md` and print it. Format:

# Device test — Session <ID>
Prereqs: <build installed on iPhone/Watch; settings needed; e.g., Action Button set to Steady>
1. <Action> → Expect: <observable result>. Pass if: <criterion, with numbers where the PRD has them>.
...
Report back: for each step, PASS / FAIL + one sentence. For haptics and voice, describe in concrete words (too sharp, lags the voice, too quiet) — the engineer cannot feel or hear the device.

Keep it under 10 steps. Include one "real moment" step when the session touched Flow A, B, or C: use it in genuine friction and note whether anything required thinking too early.
