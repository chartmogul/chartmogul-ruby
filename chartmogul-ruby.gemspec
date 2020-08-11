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
  spec.required_ruby_version = '>= 2.3'

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_dependency 'faraday', '~> 1.0.0'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.79'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.38'
  spec.add_development_dependency 'rubocop-thread_safety', '~> 0.3.4'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'vcr', '~> 5.1'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
