require 'spec_helper'

describe 'chartmogul retry request' do
  let(:url) { "https://api.chartmogul.com/v1/customers/search?email=no@email.com" }

  before do
    stub_request(:get, url).to_return(status: 503, body: "", headers: {})
    ChartMogul::Customers.instance_variable_set(:@connection, nil) # clearing memoized connection
    config = instance_double(
      "ChartMogul::Configuration", account_token: 'dummy-token', secret_key: 'dummy-token', max_retries: max_retries
    )
    allow(ChartMogul).to receive(:config).and_return(config)
    stub_const('ChartMogul::APIResource::INTERVAL', 0) # avoid waiting when running specs
  end

  describe 'API Interactions' do
    context 'when retries are set' do
      let(:max_retries) { 20 }

      it 'retries the request before it dies' do
        VCR.turned_off do
          expect { ChartMogul::Customer.search('no@email.com') }.to raise_error(ChartMogul::ChartMogulError)
          expect(WebMock).to have_requested( :get, url).times(21)
        end
      end
    end

    context 'when retries are set to zero' do
      let(:max_retries) { 0 }

      it 'does not retry the request' do
        VCR.turned_off do
          expect { ChartMogul::Customer.search('no@email.com') }.to raise_error(ChartMogul::ChartMogulError)
          expect(WebMock).to have_requested(:get, url).times(1)
        end
      end
    end
  end
end
