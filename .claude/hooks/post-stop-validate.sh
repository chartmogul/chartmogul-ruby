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
rubocop_out=$(echo "$files" | xargs bundle exec rubocop -a 2>&1) || true
offenses=$(echo "$rubocop_out" | grep -E "^.+:\d+:\d+:" | head -20)

# Fast test suite (~1s)
rspec_out=$(bundle exec rspec 2>&1) || true
failures=$(echo "$rspec_out" | grep -E "^rspec .+ --failures|^\s+\d+\) " | head -20)

ctx=""
if [[ -n "$offenses" ]]; then
  ctx+="rubocop offenses remaining after autocorrect:\n$offenses\n"
fi
if [[ -n "$failures" ]]; then
  ctx+="rspec failures:\n$failures\n"
fi

if [[ -n "$ctx" ]]; then
  jq -n --arg ctx "$ctx" '{
    "hookSpecificOutput": {
      "hookEventName": "Stop",
      "additionalContext": $ctx
    }
  }'
fi

exit 0
