#!/bin/bash
# Records which subagents ran this session (for the closing summary). Non-blocking.
INPUT=$(cat)
AGENT=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
mkdir -p .claude/state
echo "$(date '+%H:%M') $AGENT" >> .claude/state/subagents-this-session.log
exit 0
