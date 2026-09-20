#!/bin/bash
# Prints the session ritual and the current build-plan pointer so every session opens the same way.
cat <<'MSG'
[Steady Reset] Session ritual: (1) read docs/BUILD_PLAN.md, (2) state which session ID you are executing, what is done, and what this session will produce, (3) wait for Robert's sign-off, (4) work, (5) close with what is unverified and the device test script.
[Steady Reset] Non-negotiable rules are in CLAUDE.md. Delegate builds to @xcode-builder, reviews to @swift-reviewer + @prd-compliance-checker, UI to @ui-designer, tests to @qa-tester.
MSG
if [ -f .claude/state/current-session.txt ]; then echo "[Steady Reset] Last recorded session: $(cat .claude/state/current-session.txt)"; fi
exit 0
