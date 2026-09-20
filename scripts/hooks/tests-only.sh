#!/bin/bash
# Used by qa-tester: allow edits only under test directories.
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE" ] && exit 0
case "$FILE" in
  */Packages/SteadyCore/Tests/*|Packages/SteadyCore/Tests/*|*/App/*Tests/*|App/*Tests/*) exit 0;;
  *) echo "Blocked: qa-tester may only edit test files. Report the needed production change instead." >&2; exit 2;;
esac
