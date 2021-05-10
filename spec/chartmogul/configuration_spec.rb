# frozen_string_literal: true

require 'spec_helper'

describe 'ChartMogul configuration' do
  describe 'account_token' do
    it 'sets the configuration' do
      ChartMogul.account_token = 'abcdef1234567890'
      expect(ChartMogul.account_token).to eq('abcdef1234567890')
    end

    it 'raises a ChartMogul::ConfigurationError when not set' do
      ChartMogul.account_token = nil
      expect { ChartMogul.account_token }.to raise_error(ChartMogul::ConfigurationError)
    end
  end

  describe 'secret_key' do
    it 'sets the configuration' do
      ChartMogul.secret_key = 'abcdef1234567890'
      expect(ChartMogul.secret_key).to eq('abcdef1234567890')
    end

    it 'raises a ChartMogul::ConfigurationError when not set' do
      ChartMogul.secret_key = nil
      expect { ChartMogul.secret_key }.to raise_error(ChartMogul::ConfigurationError)
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

  describe 'global_account_token' do
    it 'sets the global configuration' do
      ChartMogul.global_account_token = 'abcdef1234567890'
      expect(ChartMogul.account_token).to eq('abcdef1234567890')
      expect(ChartMogul.global_account_token).to eq('abcdef1234567890')
    end

    it 'thread-safe overrides global configuration' do
      ChartMogul.global_account_token = 'abcdef1234567890'
      expect(ChartMogul.account_token).to eq('abcdef1234567890')
      ChartMogul.account_token = '00000000000'
      expect(ChartMogul.account_token).to eq('00000000000')
    end
  end
end
