#!/bin/bash
bundle exec rubocop 2>&1
bundle exec rspec 2>&1
gem build chartmogul-ruby.gemspec 2>&1

exit 0
