#!/bin/bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE" == *.rb ]]; then
  bundle exec rubocop -a "$FILE" 2>/dev/null
  bundle exec rspec 2>&1
  gem build chartmogul-ruby.gemspec 2>&1
fi

exit 0
