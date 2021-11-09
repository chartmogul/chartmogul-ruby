# frozen_string_literal: true

require 'spec_helper'

describe 'ChartMogul configuration' do
  describe 'api_key' do
    it 'sets the configuration' do
      ChartMogul.api_key = 'abcdef1234567890'
      expect(ChartMogul.api_key).to eq('abcdef1234567890')
    end

    it 'raises a ChartMogul::ConfigurationError when not set' do
      ChartMogul.api_key = nil
      expect { ChartMogul.api_key }.to raise_error(ChartMogul::ConfigurationError)
    end
  end

  describe 'api base' do
    it 'sets the api base' do
      dummy_base = 'https://dummy-api.chartmogul.com'

      ChartMogul.api_base = dummy_base
      expect(ChartMogul.api_base).to eq dummy_base
    end

    it 'uses default api base when not set' do
      ChartMogul.api_base = nil

      expect(ChartMogul.api_base).to eq ChartMogul::API_BASE
    end
  end

  describe 'global_api_key' do

    after { ChartMogul.global_api_key = nil }

    it 'sets the global configuration' do
      ChartMogul.global_api_key = 'abcdef1234567890'
      expect(ChartMogul.api_key).to eq('abcdef1234567890')
      expect(ChartMogul.global_api_key).to eq('abcdef1234567890')
    end

    it 'thread-safe overrides global configuration' do
      ChartMogul.global_api_key = 'abcdef1234567890'
      expect(ChartMogul.api_key).to eq('abcdef1234567890')
      ChartMogul.api_key = '00000000000'
      expect(ChartMogul.api_key).to eq('00000000000')
    end
  end
end
