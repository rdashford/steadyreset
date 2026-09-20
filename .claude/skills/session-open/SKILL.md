---
name: session-open
description: Open a build session the Steady Reset way — read the build plan, state the session ID, what is done, what will be produced, and wait for Robert's sign-off. Use at the start of every Claude Code session or when Robert types /session-open.
---

1. Read `docs/BUILD_PLAN.md` Section 5 and `.claude/state/current-session.txt` if it exists.
2. Run `git log --oneline -n 10` and `git status --short`.
3. Write a five-line opener:
   - Session: <ID and title from the plan>
   - Done so far: <from git log and the state file, one line>
   - This session will produce: <the plan row's "Done when">
   - Robert will need to: <the plan row's "Robert tests">, plus any account/device prerequisite
   - Agents I will use: <e.g., xcode-builder after edits; swift-reviewer + prd-compliance-checker + ui-designer in parallel before commit; qa-tester for tests>
4. Stop and wait for Robert's sign-off. Do not edit files before it.
5. After sign-off, write the session ID to `.claude/state/current-session.txt`.
