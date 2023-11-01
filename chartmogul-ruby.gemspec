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

  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'faraday-retry', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'pry', '~> 0.14.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.79'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.38'
  spec.add_development_dependency 'rubocop-thread_safety', '~> 0.3.4'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'vcr', '~> 5.1'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
