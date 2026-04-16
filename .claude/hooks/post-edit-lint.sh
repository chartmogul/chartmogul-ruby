#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 0

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only track .rb files, skip vendored/generated paths
if [[ "$FILE" == *.rb ]] && [[ "$FILE" != */vendor/* ]] && [[ "$FILE" != */coverage/* ]]; then
  TRACKER="/tmp/claude-edited-rb-files.$$"
  # Append and dedup
  echo "$FILE" >> "$TRACKER"
  sort -u "$TRACKER" -o "$TRACKER"
fi

exit 0
