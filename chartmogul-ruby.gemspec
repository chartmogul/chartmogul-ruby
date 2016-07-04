# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chartmogul/version'

Gem::Specification.new do |spec|
  spec.name          = 'chartmogul-ruby'
  spec.version       = ChartMogul::VERSION
  spec.authors       = ['Jason Langenauer']
  spec.email         = ['jason@chartmogul.com']

  spec.summary       = 'Chartmogul API Ruby Client'
  spec.description   = 'Official Ruby client for ChartMogul\'s API'
  spec.homepage      = 'https://github.com/chartmogul/chartmogul-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~>0.9'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
end
