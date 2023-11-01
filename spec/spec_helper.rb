# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start do
  add_filter 'vendor/ruby'
end

require 'chartmogul'
require 'vcr'
require 'webmock/rspec'
require_relative 'support/shared_example_raises_deprecated_param_error'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.filter_sensitive_data('Basic hidden') do |interaction|
    interaction.request.headers['Authorization'].first # returns an array
  end
end

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do |example|
    Thread.current[ChartMogul::CONFIG_THREAD_KEY] = nil

    if example.metadata[:uses_api]
      ChartMogul.api_key = ENV['TEST_API_KEY'] || 'dummy-token'
    end
  end
end
