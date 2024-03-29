# frozen_string_literal: true

require 'spec_helper'

describe 'chartmogul retry request' do
  let(:url) { 'https://api.chartmogul.com/v1/customers/search?email=no@email.com' }
  let(:api_base) { 'https://api.chartmogul.com' }

  before do
    Thread.current[ChartMogul::APIResource::THREAD_CONNECTION_KEY] = nil
    config = instance_double(
      'ChartMogul::Configuration', api_key: 'dummy-token',
                                   max_retries: max_retries, api_base: api_base
    )
    allow(ChartMogul).to receive(:config).and_return(config)
    stub_const('ChartMogul::APIResource::INTERVAL', 0) # avoid waiting when running specs
  end

  describe 'Server side failed requests' do
    before { stub_request(:get, url).to_return(status: 503) }

    context 'when retries are set' do
      let(:max_retries) { 20 }

      it 'retries the request before it dies' do
        VCR.turned_off do
          expect { ChartMogul::Customer.search('no@email.com') }.to raise_error(ChartMogul::ChartMogulError)
          expect(WebMock).to have_requested(:get, url).times(21)
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

  describe 'Client side failed requests' do
    let(:max_retries) { 20 }

    context 'when it times out' do
      before { stub_request(:get, url).to_timeout.times(10).then.to_return(status: 200, body: '{}') }

      it 'retries the request' do
        VCR.turned_off do
          ChartMogul::Customer.search('no@email.com')
          expect(WebMock).to have_requested(:get, url).times(11)
        end
      end
    end

    context 'when there is no connection' do
      before { stub_request(:get, url).to_raise(SocketError).times(3).then.to_return(status: 200, body: '{}') }

      it 'retries the request' do
        VCR.turned_off do
          ChartMogul::Customer.search('no@email.com')
          expect(WebMock).to have_requested(:get, url).times(4)
        end
      end
    end
  end
end
