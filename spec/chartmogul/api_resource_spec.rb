# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::APIResource do
  describe 'connection' do
    it 'works when credentials are updated', vcr: { record: :all, exclusive: true } do
      set_invalid_credentials
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)

      set_valid_credentials
      expect { ChartMogul::Ping.ping }.not_to raise_error
    end

    it 'works in a threaded environment', vcr: { record: :all, exclusive: true } do
      t1 = Thread.new do
        set_invalid_credentials
        expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)
      end

      t2 = Thread.new do
        set_valid_credentials
        expect { ChartMogul::Ping.ping }.not_to raise_error
      end
      [t1, t2].join
    end
  end

  def set_valid_credentials
    ChartMogul.account_token = 'dummy-token'
    ChartMogul.secret_key = 'dummy-token'
  end

  def set_invalid_credentials
    ChartMogul.account_token = 'invalid'
    ChartMogul.secret_key = 'invalid'
  end
end
