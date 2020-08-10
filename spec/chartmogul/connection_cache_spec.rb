# frozen_string_literal: true

require 'spec_helper'

describe 'Connection cache' do
  before do
    stub_request(:get, "https://api.chartmogul.com/v1/ping").
    to_return(status: 200, body: '{"data":"pong!"}')

    stub_request(:get, "https://example.chartmogul.com/v1/ping").
    to_return(status: 200, body: '{"data":"pong!"}')
  end


  it 'invalidates the connection and uses new one' do
    VCR.turned_off do
      ChartMogul.account_token = 'dummy-token'
      ChartMogul.secret_key = 'dummy-token'
      ChartMogul.max_retries = 0

      pong = ChartMogul::Ping.ping
      expect(WebMock).to have_requested(:get, "https://api.chartmogul.com/v1/ping")
      expect(pong.data).to eq('pong!')

      ChartMogul.api_base = 'https://example.chartmogul.com'
      pong = ChartMogul::Ping.ping
      expect(WebMock).to have_requested(:get, "https://example.chartmogul.com/v1/ping")
      expect(pong.data).to eq('pong!')
    end
  end
end