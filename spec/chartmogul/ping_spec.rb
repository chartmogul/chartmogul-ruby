require 'spec_helper'

describe ChartMogul::Ping do
  before do
    allow(ChartMogul).to receive(:max_retries).and_return(0)
  end
  describe 'pings', vcr: true do
    it 'when credentials correct', uses_api: true do
      pong = ChartMogul::Ping.ping

      expect(pong.data).to eq('pong!')
    end

    it 'and fails on incorrect credentials', uses_api: true do
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)
    end

    it 'and fails with 500 internal server error', uses_api: true do
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::ServerError)
    end

    it 'and fails with 504 gateway timeout error', uses_api: true do
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::ServerError)
    end
  end
end
