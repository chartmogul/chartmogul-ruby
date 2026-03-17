# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Account, uses_api: true do
  describe 'API interactions' do
    around(:all) do |example|
      VCR.use_cassette('ChartMogul_Account/returns_details_of_current_account', &example)
    end

    let(:account) { ChartMogul::Account.retrieve }

    it 'returns the right account attributes' do
      expect(account).to have_attributes(
        name: 'Example Test Company',
        currency: 'EUR',
        time_zone: 'Europe/Berlin',
        week_start_on: 'sunday'
      )
    end
  end

  describe '.retrieve with include parameter', uses_api: false do
    it 'sends GET with include query param' do
      allow(described_class).to receive(:connection).and_return(double('connection'))
      expect(described_class.connection).to receive(:get) do |path|
        expect(path).to eq('/v1/account?include=churn_recognition,refund_handling')
        double('response', body: '{"id": "acct_123", "name": "Test", "currency": "USD", "time_zone": "UTC", "week_start_on": "monday", "churn_recognition": {"mode": "immediate"}, "refund_handling": {"mode": "credit"}}')
      end

      result = described_class.retrieve(include: %w[churn_recognition refund_handling])
      expect(result.id).to eq('acct_123')
      expect(result.churn_recognition).to be_a(Hash)
      expect(result.refund_handling).to be_a(Hash)
    end

    it 'sends GET without include when not provided' do
      allow(described_class).to receive(:connection).and_return(double('connection'))
      expect(described_class.connection).to receive(:get) do |path|
        expect(path).to eq('/v1/account')
        double('response', body: '{"id": "acct_123", "name": "Test", "currency": "USD", "time_zone": "UTC", "week_start_on": "monday"}')
      end

      result = described_class.retrieve
      expect(result.id).to eq('acct_123')
    end
  end
end
