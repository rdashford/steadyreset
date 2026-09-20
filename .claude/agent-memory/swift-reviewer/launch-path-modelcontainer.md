---
name: launch-path-modelcontainer
description: The app's .modelContainer is on the launch path despite a comment claiming it is lazy — recheck on every SteadyResetApp change
metadata:
  type: project
---

`SteadyResetApp` applies `.modelContainer(for:)` to the `WindowGroup` scene while a doc comment above it claims the container is "created lazily off the critical path". SwiftUI builds that container synchronously during the first scene evaluation, i.e. before the first frame and before `RootView`'s prewarm `.task` runs.

**Why:** CLAUDE.md rule 1 and PRD E1 forbid a SwiftData load on the Stage 1–2 path; the comment makes the violation look already-solved, so it survives review.
**How to apply:** Do not trust that comment. Re-flag until the container is injected only into the branches that persist (Home, post-Stage-2, debrief) and `ResetView` can render and start haptics without a `ModelContext`. Related: [[stage2-recurring-defects]].
