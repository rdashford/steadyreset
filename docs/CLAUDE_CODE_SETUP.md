**CLAUDE CODE SETUP GUIDE**

**Steady Reset**

*How to set up Claude Code for this repository so that specialist agents
build, verify, review, and audit the work — what agents exist, how they
are defined, when each runs, and how to confirm the setup is correct.*

**Version:** v1

**Date:** September 16, 2026

**Owner:** Robert Ashford, PhD, MSW

**Companion files:** SteadyReset_skeleton_v2.zip contains every file
this guide describes, already in place under .claude/, scripts/hooks/,
and docs/.

**Verified against:** Claude Code documentation at code.claude.com/docs
as of this date (subagents, agent teams, parallel-agents overview,
desktop iOS Simulator). Claude Code changes weekly; where a flag or
behavior matters, the section cites the doc page to re-check.

**Contents**

**1. What 'agents' means in Claude Code, and what we use**

Claude Code has four distinct mechanisms for parallel or delegated work.
They are often lumped together as 'agent swarms'; they are not
interchangeable, and choosing the wrong one costs tokens and
coordination. 'Managed agents' is not a Claude Code term; the nearest
concept is managed settings, which is organization-wide configuration
and does not apply to a two-person project.

| **Mechanism**     | **What it is**                                                                                                                                                                                                                 | **Cost and status**                                                                                                       | **Steady Reset uses it for**                                                                                                                                                          |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Subagents         | Specialists defined as Markdown files in .claude/agents/. The main session delegates a task; the subagent works in its own context with its own tools and permissions and returns a summary. Run in the background by default. | Moderate. Stable, on by default.                                                                                          | The backbone: build/test, code review, PRD compliance, UI review, accessibility, QA, copy, privacy, clinical content. Nine defined agents.                                            |
| Agent teams       | Several full Claude Code sessions with a lead, a shared task list, and direct messaging between teammates.                                                                                                                     | High (each teammate is a full session). Experimental; off by default; enable with CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1. | Two recipes only: parallel multi-lens review of a large diff, and competing-hypothesis debugging of a hard bug (e.g., a launch-time regression). Turned on for the session, then off. |
| Dynamic workflows | A script Claude writes that fans out many subagents and cross-checks their findings; rerunnable.                                                                                                                               | Scales with the job. Available.                                                                                           | Repo-wide audits before TestFlight: accessibility across every view, copy across every string, privacy across every service.                                                          |
| Agent view        | One screen to dispatch and monitor independent background sessions (claude agents).                                                                                                                                            | One session per task. Research preview.                                                                                   | Rarely: when two unrelated sessions from the build plan can run at once (e.g., voice pipeline spike and a Watch task), each in its own worktree.                                      |

> **Default posture:** Subagents on, agent teams off. settings.json sets
> CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS to 0 so Claude cannot silently
> form a team when it names a subagent. Turn it on deliberately for a
> recipe in Section 8, then turn it back off.

**1.1 Where the swarm helps and where it doesn't**

- Helps: anything that produces verbose output (builds, tests, greps),
  anything that benefits from an independent lens (review, audit,
  compliance), and anything that should be constrained (a tester that
  can only touch test files).

- Doesn't: haptic and voice tuning, real-moment testing, and anything
  the Simulator cannot run. No agent can feel the sigh pattern. Those
  loops run through Robert's device script, not through more agents.

- Costs: every subagent result returns into the main context. Three
  parallel reviewers on a small diff is fine; twelve is noise. The
  standard loop in Section 7 is sized for one feature at a time.

**2. Install and open the project**

1.  Install Claude Code Desktop for macOS and sign in with the same
    account used for this chat. Confirm the version is current (Help →
    About). Xcode 26.3 or later can also host Claude Code directly;
    either surface works, but the Desktop app is the one with the iOS
    Simulator pane.

2.  Install Xcode 26 or later from the App Store and launch it once to
    install components. In Terminal: xcode-select -p should print an
    Xcode path.

3.  Install Homebrew, then: brew install xcodegen jq swiftformat. jq is
    required by the hook scripts; swiftformat is optional.

4.  Unzip SteadyReset_skeleton_v2.zip. Create a private GitHub
    repository and push the folder as the initial commit (git init &&
    git add -A && git commit -m 'Skeleton v2' then push).

5.  In Claude Code Desktop, open the Code tab and start a session with
    the SteadyReset folder as the project. Accept the workspace trust
    dialog. Trust is what allows the project's hooks and agent
    frontmatter to run; without it, agents still run but their hooks are
    silently skipped.

6.  Permission mode: auto mode is the default on Pro and Max plans and
    is right for this project. It reviews commands with a classifier;
    the deny list in settings.json is still enforced. Use plan mode
    (Shift+Tab) for Session 0.1's first read-through of the skeleton.

7.  Type /doctor. It should report the nine agents loaded, the hooks
    registered, and no duplicate agent names. Type /hooks to see the
    four hook events. Type /context to see what CLAUDE.md and rules cost
    at startup.

8.  Type /session-open. If the skill prints the five-line opener and
    stops for your sign-off, the setup is working.

**3. The .claude directory in this repository**

| **Path**                             | **Purpose**                                                                                                                             | **Notes**                                                                                                    |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| CLAUDE.md (repo root)                | Project memory: platform, build commands, the nine non-negotiable product rules, the agent roster and standard loop, the session ritual | Loads into every session and every custom subagent. Keep it short; detail belongs in agent bodies and skills |
| .claude/settings.json                | Permissions allow/deny, environment variables, hooks                                                                                    | Checked in. Personal overrides go in .claude/settings.local.json (git-ignored)                               |
| .claude/agents/\*.md                 | Nine subagent definitions                                                                                                               | YAML frontmatter + system prompt. Watched live; edits apply to the next delegation without restart           |
| .claude/skills/\*/SKILL.md           | Three skills: /session-open, /device-test-script, /prd                                                                                  | Skills run in the main context; agents run in their own                                                      |
| scripts/hooks/\*.sh                  | Hook scripts: session ritual, protected paths, Swift formatting, tests-only guard, subagent log                                         | Must be executable (chmod +x). Read JSON on stdin; exit 2 blocks with a message                              |
| .claude/agent-memory/swift-reviewer/ | Persistent memory the reviewer builds across sessions                                                                                   | Created automatically; commit it so the reviewer remembers recurring issues                                  |
| .claude/state/                       | Session pointer and subagent log written by hooks                                                                                       | Git-ignored                                                                                                  |
| docs/PRD.md, docs/BUILD_PLAN.md      | Markdown copies of the PRD and build plan so agents can grep them                                                                       | Regenerated with pandoc when the .docx changes; hooks block direct edits                                     |

**4. The agent roster**

Each agent is one Markdown file. The frontmatter sets name, description
(which is how Claude decides when to delegate), tools (allowlist),
model, optional memory and hooks. The body is the agent's system prompt.
Every file is in the skeleton; the table is the map.

| **Agent**                 | **Job**                                                                                                                                 | **Tools**                           | **Model** | **When it runs**                                            |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|-----------|-------------------------------------------------------------|
| xcode-builder             | Builds and tests; returns failures only, never logs                                                                                     | Bash, Read, Grep, Glob              | sonnet    | After every Swift edit; before review; before commit        |
| swift-reviewer            | Read-only review: product rules, Swift 6 concurrency, SwiftData, SwiftUI, timing, logging. Keeps project memory of recurring issues     | Read, Grep, Glob, Bash              | inherit   | After a green build, before commit                          |
| prd-compliance-checker    | Maps code to PRD requirement IDs and acceptance criteria; flags principle violations                                                    | Read, Grep, Glob, Bash              | sonnet    | When a session claims a requirement done; before TestFlight |
| ui-designer               | Designs and critiques SwiftUI for the flooded user; can draft views and capture simulator screenshots                                   | Read, Grep, Glob, Bash, Write       | inherit   | On any View change; before Robert sees a new screen         |
| accessibility-auditor     | VoiceOver, Dynamic Type, Reduce Motion, contrast, non-visual completion paths                                                           | Read, Grep, Glob, Bash              | sonnet    | After View changes; before every TestFlight                 |
| qa-tester                 | Writes and runs Swift Testing and XCUITests; may edit only test directories (hook-enforced)                                             | Read, Grep, Glob, Bash, Edit, Write | inherit   | After review, before commit                                 |
| copy-editor               | Brand voice and word list across every user-facing string                                                                               | Read, Grep, Glob                    | sonnet    | After copy changes; before release                          |
| privacy-auditor           | Network/model calls on Stage 1–2, HealthKit leakage, crisis pre-check, free-tier inference, secrets                                     | Read, Grep, Glob, Bash              | inherit   | After Service changes; before every TestFlight              |
| clinical-content-reviewer | Checks scripts, safety copy, EMA items, companion prompts against PRD evidence and safety sections; prepares for the licensed clinician | Read, Grep, Glob                    | inherit   | On content changes; before clinician review                 |

**4.1 Design choices in the roster**

- Read-only by default. Only the main session, ui-designer (views) and
  qa-tester (tests) can write. Reviewers that cannot edit cannot 'fix' a
  finding by weakening the code.

- Model by job. Builders, compliance, accessibility and copy run on
  Sonnet: structured, checklist work at lower cost. Reviewers that need
  judgment inherit the session model.

- Descriptions are short and specific. Claude routes by description;
  Claude Code warns when combined descriptions exceed 15,000 tokens.
  Detail lives in the body, which loads only when the agent runs.

- One agent has memory. swift-reviewer uses memory: project so recurring
  mistakes become institutional knowledge; commit .claude/agent-memory/
  to keep it.

- One agent has a frontmatter hook. qa-tester's PreToolUse hook blocks
  writes outside test folders, so the constraint is enforced, not
  requested.

- No agent implements features. The main session implements; that keeps
  one author, one context, and one place for Robert's sign-off.
  Subagents verify.

**4.2 Anatomy of one definition (xcode-builder)**

> ---
>
> name: xcode-builder
>
> description: Builds the Xcode project or runs swift test / xcodebuild
> test and returns ONLY the failures. Use proactively after any Swift
> edit, before review, and before committing.
>
> tools: Bash, Read, Grep, Glob
>
> model: sonnet
>
> color: blue
>
> ---
>
> You build and test Steady Reset and report failures only. … (commands,
> report format, limits)

Three things make this work: 'Use proactively' in the description
encourages Claude to delegate without being asked; the tools allowlist
omits Edit and Write so it cannot change code; and the report format
caps raw log lines so the main conversation stays small.

**4.3 Adding or changing an agent**

- Ask Claude in the session: 'Create a project subagent in
  .claude/agents/ that …' and review the file. Or edit the Markdown
  directly; changes are picked up within seconds.

- Keep names unique and lowercase-hyphenated. /doctor reports
  duplicates.

- Run claude plugin validate .claude/agents to check frontmatter parses
  before a session.

**5. Hooks**

Hooks are shell commands Claude Code runs at lifecycle events. They
receive JSON on stdin and can block an action by exiting with code 2 and
a message on stderr. They make rules structural rather than advisory.

| **Event**                           | **Script**       | **Effect**                                                                                                                    |
|-------------------------------------|------------------|-------------------------------------------------------------------------------------------------------------------------------|
| SessionStart                        | session-start.sh | Prints the session ritual and the last recorded session ID so every session opens the same way                                |
| PreToolUse (Edit\|Write)            | protect-paths.sh | Blocks edits to the generated .xcodeproj/.pbxproj, secrets (.env, .p8, AuthKey), and the PRD; tells Claude what to do instead |
| PostToolUse (Edit\|Write)           | format-swift.sh  | Runs swiftformat on the edited Swift file if installed; never fails the edit                                                  |
| SubagentStop                        | subagent-stop.sh | Appends the agent name to .claude/state/subagents-this-session.log for the closing summary                                    |
| PreToolUse in qa-tester frontmatter | tests-only.sh    | Allows the tester to write only under Tests directories                                                                       |

Hooks in settings.json also fire inside subagents, so protect-paths.sh
guards every agent, not just the main session. Project hooks run only
after you accept the workspace trust dialog.

**6. Skills**

| **Skill**          | **Invoke**                              | **What it does**                                                                                                                                                 |
|--------------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| session-open       | /session-open or automatically at start | Reads the build plan and git log, writes the five-line opener, stops for sign-off, records the session ID                                                        |
| device-test-script | /device-test-script at session close    | Writes docs/device-tests/\<session\>.md: under ten numbered steps covering only what the Simulator cannot verify, with pass criteria and how to describe haptics |
| prd                | /prd R6                                 | Quotes a requirement row or a section from docs/PRD.md verbatim so neither of us works from memory                                                               |

Two bundled skills matter too: /design drafts editable UI artboards
(useful for ui-designer to show Robert a screen before code), and
/verify is a user-only verification pass on a change. /code-review runs
a multi-agent review of a diff; on this project prefer the three named
reviewers because they carry the product rules.

**7. How a build session runs with the swarm**

This is the loop CLAUDE.md prescribes. The main session does the
implementing; agents verify at each gate. Steps in the same row run in
parallel as background subagents.

| **Step**  | **Who**                                                              | **Gate**                                                           |
|-----------|----------------------------------------------------------------------|--------------------------------------------------------------------|
| Open      | /session-open → Robert signs off                                     | No edits before sign-off                                           |
| Implement | Main session, following the build-plan row                           | —                                                                  |
| Build     | @xcode-builder                                                       | BUILD PASS on iPhone and Watch; tests green                        |
| Review    | @swift-reviewer + @prd-compliance-checker + @ui-designer (parallel)  | No Critical findings; requirement rows Met or 'device test needed' |
| Fix       | Main session                                                         | —                                                                  |
| Test      | @qa-tester writes tests for the acceptance criteria → @xcode-builder | New tests pass; nothing weakened                                   |
| Commit    | Main session, message includes the session ID                        | main stays buildable                                               |
| Close     | /device-test-script                                                  | Robert has a numbered script; unverified items named               |

**7.1 Before every TestFlight build**

Add a release gate: @accessibility-auditor, @privacy-auditor, and
@copy-editor over the whole app, plus @prd-compliance-checker over every
requirement marked Launch in the sessions shipped. For a full-repo pass,
use a dynamic workflow (Section 8.3) rather than one agent reading
everything.

**7.2 Prompts that trigger the loop**

> Use @xcode-builder to build both targets and report failures.
>
> Run @swift-reviewer, @prd-compliance-checker and @ui-designer in
> parallel on the current diff for session 1.5.
>
> Have @qa-tester write tests for R1 and R2, then rebuild.
>
> /device-test-script for session 1.5

**8. Recipes for the heavier mechanisms**

**8.1 Agent team: parallel multi-lens review of a large diff**

When a session lands a large change (e.g., Flow C parts 1 and 2
together), turn on agent teams for that review and spawn three teammates
from the existing definitions:

> 1\. In .claude/settings.local.json set "env":
> {"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"}
>
> 2\. Prompt: Spawn three teammates using the swift-reviewer,
> privacy-auditor and ui-designer agent types to review the diff for
> session 1.6. Have them share findings and challenge each other where
> they disagree, then give me one consolidated list.
>
> 3\. When done: set the variable back to "0".

Teammates load CLAUDE.md and the agent body but not the lead's history,
so name the session ID and files in the spawn prompt. Their permission
prompts appear in the lead session.

**8.2 Agent team: competing-hypothesis debugging**

For a bug with several plausible causes (launch-to-first-haptic
regressing above 2 s is the likely first one): 'Spawn 3 teammates to
investigate why cold launch to first haptic is now 3.1 s. One tests the
hypothesis that SwiftData is on the launch path, one that the haptic
engine is not prewarmed, one that the App Intent is opening a scene
before the Router is ready. Have them try to disprove each other and
report the surviving explanation with evidence.' Turn teams off
afterward.

**8.3 Dynamic workflow: repo-wide audits**

Before TestFlight: 'Write a workflow that runs the accessibility-auditor
over every View file in App/, one subagent per file, then a second pass
that checks each FAIL against the file to confirm it is real, and
produces docs/audits/accessibility-\<date\>.md.' Rerun the same workflow
for copy-editor over every file containing UI strings and
privacy-auditor over App/SteadyReset/Services. /workflows shows
progress.

**8.4 Agent view: two independent sessions**

When two build-plan sessions touch disjoint files (0.5 voice pipeline
and 0.4 Watch), run claude agents, dispatch both, each in its own
worktree, and check back. Do not do this for sessions that share files.

**9. Permissions and settings**

settings.json allows read/edit tools and the specific commands the build
needs (swift test, xcodegen, xcodebuild, xcrun simctl, git
status/diff/add/commit/checkout, swiftformat). It denies force pushes,
hard resets, recursive deletes from root, and reading any secret. Auto
mode's classifier handles the rest; the deny list is absolute.

- Env: agent teams off; subagent nesting capped at two layers (a
  reviewer may dispatch a verifier per finding; that verifier may not
  spawn further).

- Personal settings (a different simulator name, tmux for split panes)
  go in .claude/settings.local.json, which is not committed.

- Backend/ (Phase 2) gets its own nested CLAUDE.md and a rule that its
  .env is never read.

**10. Usage and cost**

- Subagents multiply tokens: three parallel reviewers cost roughly three
  reviews. The loop runs them once per feature, not per edit.

- Sonnet-routed agents (builder, compliance, accessibility, copy) are
  the bulk of the volume and the cheapest. If plan limits bite, set
  CLAUDE_CODE_SUBAGENT_MODEL to sonnet with
  CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1 in settings.local.json to force
  every agent onto Sonnet for that session.

- Agent teams are the expensive tool. Two recipes, deliberate on/off.

- /usage shows what is driving limits; /tasks shows which model each
  running agent is on.

**11. Verifying the setup**

| **Check**      | **Command**                                     | **Expected**                                                                                                                            |
|----------------|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Agents loaded  | /doctor                                         | Nine agents, no duplicate names, hooks registered                                                                                       |
| Hooks visible  | /hooks                                          | SessionStart, PreToolUse, PostToolUse, SubagentStop listed                                                                              |
| Trust accepted | Edit a .swift file                              | format-swift.sh runs (file reformatted if swiftformat installed); try editing project.yml's generated .xcodeproj → blocked with message |
| Skill works    | /session-open                                   | Five-line opener, then stops                                                                                                            |
| PRD lookup     | /prd R6                                         | Quotes the Break Focus row from docs/PRD.md                                                                                             |
| Agent runs     | Use @xcode-builder to run swift test            | Returns pass/fail summary, no raw logs                                                                                                  |
| Teams off      | Ask Claude to review with three named subagents | They appear as subagents, not teammates (no team panel)                                                                                 |
| Context cost   | /context                                        | CLAUDE.md and agent descriptions well under the 15k-token warning                                                                       |

**12. Keeping it current**

- Claude Code ships weekly. Re-read code.claude.com/docs/en/whats-new
  monthly; the pages cited here are sub-agents, agent-teams, agents
  (overview), hooks, skills, settings-reference, and
  desktop-ios-simulator.

- When the PRD changes (in chat), regenerate docs/PRD.md with pandoc and
  commit; agents grep that file.

- When a reviewer keeps finding the same issue, put the rule in
  CLAUDE.md (one line) rather than in the agent body, so the main
  session stops making the mistake.

- Prune: if an agent has not been useful in a phase, delete it.
  Descriptions cost context on every session.
