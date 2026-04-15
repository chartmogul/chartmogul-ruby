#!/bin/bash
bundle exec rspec 2>&1
gem build chartmogul-ruby.gemspec 2>&1

exit 0
