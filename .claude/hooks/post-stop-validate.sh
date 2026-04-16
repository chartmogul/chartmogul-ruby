#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 0

TRACKER="/tmp/claude-edited-rb-files.$$"

# Nothing tracked this turn - skip
if [[ ! -f "$TRACKER" ]]; then
  exit 0
fi

files=$(cat "$TRACKER")
rm -f "$TRACKER"

if [[ -z "$files" ]]; then
  exit 0
fi

# Batch rubocop autocorrect on all edited files
output=$(echo "$files" | xargs bundle exec rubocop -a 2>&1) || true

# Filter to remaining offenses only (skip clean output)
offenses=$(echo "$output" | grep -E "^.+:\d+:\d+:" | head -20)

if [[ -n "$offenses" ]]; then
  jq -n --arg ctx "rubocop offenses remaining after autocorrect:\n$offenses" '{
    "hookSpecificOutput": {
      "hookEventName": "Stop",
      "additionalContext": $ctx
    }
  }'
fi

exit 0
