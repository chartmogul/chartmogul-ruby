#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 0

# Read session_id from hook input and persist via CLAUDE_ENV_FILE
# so the edit tracker and stop hook share the same file path
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
if [[ -n "$SESSION_ID" ]] && [[ -n "$CLAUDE_ENV_FILE" ]]; then
  echo "export CLAUDE_HOOK_SESSION_ID='$SESSION_ID'" >> "$CLAUDE_ENV_FILE"
fi

ctx=""

# Warn if Gemfile.lock is missing or stale
if [[ ! -f Gemfile.lock ]]; then
  ctx+="Gemfile.lock missing - run bundle install.\n"
elif [[ Gemfile -nt Gemfile.lock ]]; then
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
