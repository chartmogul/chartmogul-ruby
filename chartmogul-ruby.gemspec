# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chartmogul/version'

Gem::Specification.new do |spec|
  spec.name                  = 'chartmogul-ruby'
  spec.version               = ChartMogul::VERSION
  spec.authors               = ['Petr Kopac']
  spec.email                 = ['petr@chartmogul.com']

  spec.summary               = 'Chartmogul API Ruby Client'
  spec.description           = 'Official Ruby client for ChartMogul\'s API'
  spec.homepage              = 'https://github.com/chartmogul/chartmogul-ruby'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.post_install_message  = %q{
  Starting October 29 2021, we are updating our developer libraries to support the enhanced API Access Management. Please use the same API Key for both API Token and Secret Key.
  [Deprecation] - account_token/secret_key combo is deprecated. Please use API key for both fields.
  Version 3.x will introduce a breaking change in authentication configuration. For more details, please visit: https://dev.chartmogul.com/docs/authentication
  }

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_dependency 'faraday', '~> 2.8'
  spec.add_dependency 'faraday-retry', '~> 2.2'

  # Higher versions break ruby 2.7 support.
  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '= 1.56.3'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.9'
  spec.add_development_dependency 'rubocop-thread_safety', '~> 0.5.1'
  spec.add_development_dependency 'simplecov', '~> 0.21'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
