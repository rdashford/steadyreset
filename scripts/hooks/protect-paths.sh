#!/bin/bash
# Blocks edits to generated or sensitive paths. Exit 2 = block with message to Claude.
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')
[ -z "$FILE" ] && exit 0
case "$FILE" in
  *.pbxproj|*.xcodeproj/*|*.xcworkspace/*)
    echo "Blocked: the Xcode project is generated. Edit project.yml and run 'xcodegen generate'." >&2; exit 2;;
  *.env|*AuthKey*|*.p8|*.p12)
    echo "Blocked: secrets are never edited or read by Claude." >&2; exit 2;;
  docs/Steady_Reset_PRD_*.docx|docs/PRD.md)
    echo "Blocked: the PRD is revised in the chat session, not in code. Propose the change to Robert instead." >&2; exit 2;;
esac
exit 0
