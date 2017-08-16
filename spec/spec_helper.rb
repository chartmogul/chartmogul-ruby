$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'chartmogul'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do |example|
    if example.metadata[:uses_api]
      ChartMogul.account_token = ENV['TEST_ACCOUNT_TOKEN'] || 'dummy-token'
      ChartMogul.secret_key = ENV['TEST_SECRET_KEY'] || 'dummy-token'
    end
  end
end
