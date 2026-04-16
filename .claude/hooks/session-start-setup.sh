#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 0

ctx=""

# Warn if Gemfile is newer than Gemfile.lock (deps out of date)
if [[ -f Gemfile.lock && Gemfile -nt Gemfile.lock ]]; then
  ctx+="Gemfile.lock is stale - run bundle install before testing.\n"
fi

# Warn about uncommitted changes
dirty=$(git diff --name-only 2>/dev/null | head -5)
if [[ -n "$dirty" ]]; then
  ctx+="Uncommitted changes:\n$dirty\n"
fi

# Report current branch
branch=$(git branch --show-current 2>/dev/null)
if [[ -n "$branch" ]]; then
  ctx+="Branch: $branch\n"
fi

if [[ -n "$ctx" ]]; then
  jq -n --arg ctx "$ctx" '{
    "hookSpecificOutput": {
      "hookEventName": "SessionStart",
      "additionalContext": $ctx
    }
  }'
fi

exit 0
