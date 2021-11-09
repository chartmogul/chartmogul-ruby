# frozen_string_literal: true

require 'spec_helper'
require 'pry'

describe ChartMogul::APIResource do
  describe 'connection', vcr: true do
    it 'works when credentials are updated' do
      set_invalid_credentials
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)

      set_valid_credentials
      expect { ChartMogul::Ping.ping }.not_to raise_error
    end

    it 'works in a threaded environment' do
      set_invalid_credentials
      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)

      Thread.new do
        set_valid_credentials
        expect { ChartMogul::Ping.ping }.not_to raise_error
      end.join

      expect { ChartMogul::Ping.ping }.to raise_error(ChartMogul::UnauthorizedError)
    end
  end

  def set_valid_credentials
    ChartMogul.api_key = 'dummy-token'
  end

  def set_invalid_credentials
    ChartMogul.api_key = 'invalid'
  end
end
