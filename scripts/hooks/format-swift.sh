#!/bin/bash
# Formats a Swift file after Claude edits it, if swiftformat is installed. Never fails the edit.
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
case "$FILE" in
  *.swift) command -v swiftformat >/dev/null 2>&1 && swiftformat "$FILE" --quiet ;;
esac
exit 0
