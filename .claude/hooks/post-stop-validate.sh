#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 0

TRACKER="${TMPDIR:-/tmp}/claude-edited-rb-files-${CLAUDE_HOOK_SESSION_ID:-default}"

ctx=""
had_edits=false

# Batch rubocop autocorrect on tracked files (if any were edited)
if [[ -f "$TRACKER" ]]; then
  files=$(cat "$TRACKER")
  rm -f "$TRACKER"

  if [[ -n "$files" ]]; then
    had_edits=true
    rubocop_out=$(echo "$files" | xargs bundle exec rubocop -a 2>&1) || true
    offenses=$(echo "$rubocop_out" | grep -E "^.+:[0-9]+:[0-9]+:" | head -20)
    if [[ -n "$offenses" ]]; then
      ctx+="rubocop offenses remaining after autocorrect:\n$offenses\n"
    fi
  fi
fi

# Only run rspec if files were edited (~1s)
if [[ "$had_edits" == true ]]; then
  rspec_out=$(bundle exec rspec 2>&1)
  rspec_exit=$?
  if [[ $rspec_exit -ne 0 ]]; then
    summary=$(echo "$rspec_out" | grep -E "[0-9]+ examples?, [0-9]+ failures?" | tail -1)
    failed=$(echo "$rspec_out" | grep -E "^rspec .+" | head -10)
    ctx+="rspec failed ($summary):\n$failed\n"
  fi
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
