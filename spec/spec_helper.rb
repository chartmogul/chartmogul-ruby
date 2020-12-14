# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start do
  add_filter 'vendor/ruby'
end

require 'chartmogul'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
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
      ChartMogul.account_token = ENV['TEST_ACCOUNT_TOKEN'] || 'dummy-token'
      ChartMogul.secret_key = ENV['TEST_SECRET_KEY'] || 'dummy-token'
    end
  end
end
