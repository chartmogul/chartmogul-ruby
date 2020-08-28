# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Cancellation do
  describe '#initialize' do
    subject(:csv_cancellation) do
      described_class.new(
        subscription_external_id: 'subscription_id',
        customer_external_id: 'customer_id',
        date: Time.new(2020, 8, 24, 8, 22, 15)
      )
    end

    it 'sets correctly the subscription external ID' do
      expect(csv_cancellation.subscription_external_id).to eq('subscription_id')
    end

    it 'sets correctly the customer external ID' do
      expect(csv_cancellation.customer_external_id).to eq('customer_id')
    end

    it 'sets correctly the cancellation date' do
      expect(csv_cancellation.date).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'returns a struct' do
      expect(csv_cancellation).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(['Subscription external ID', 'Customer external ID', 'Date'])
    end
  end
end
