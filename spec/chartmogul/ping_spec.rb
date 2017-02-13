require 'spec_helper'

describe ChartMogul::Ping do
  describe 'pings', vcr: true do
    it 'when credentials correct', uses_api: true do
      pong = ChartMogul::Ping.ping

      expect(pong.data).to eq("pong!")
    end

    it 'and fails on incorrect credentials', uses_api: true do
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)
    end
  end
end
