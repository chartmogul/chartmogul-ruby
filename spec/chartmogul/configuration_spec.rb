require 'spec_helper'

describe 'ChartMogul configuration' do
  describe 'account_token' do
    it 'sets the configuration' do
      ChartMogul.account_token = "abcdef1234567890"
      expect(ChartMogul.account_token).to eq("abcdef1234567890")
    end

    it 'raises a ChartMogul::ConfigurationError when not set' do
      ChartMogul.account_token = nil
      expect { ChartMogul.account_token }.to raise_error(ChartMogul::ConfigurationError)
    end
  end

  describe 'secret_key' do
    it 'sets the configuration' do
      ChartMogul.secret_key = "abcdef1234567890"
      expect(ChartMogul.secret_key).to eq("abcdef1234567890")
    end

    it 'raises a ChartMogul::ConfigurationError when not set' do
      ChartMogul.secret_key = nil
      expect { ChartMogul.secret_key }.to raise_error(ChartMogul::ConfigurationError)
    end
  end
end
