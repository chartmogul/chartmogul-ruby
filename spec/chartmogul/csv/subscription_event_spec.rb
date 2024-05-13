# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::SubscriptionEvent do
  describe '#initialize' do
    subject(:csv_subscription_event) do
      described_class.new(
        external_id: 'external_id',
        subscription_set_external_id: 'subscription_set_external_id',
        effective_date: Time.new(2020, 8, 24, 8, 22, 15),
        event_order: 1000,
        invoice_external_id: 12_345
      )
    end

    it 'sets correctly the external ID' do
      expect(csv_subscription_event.external_id).to eq('external_id')
    end

    it 'sets correctly the subscription set external id' do
      expect(csv_subscription_event.subscription_set_external_id).to eq('subscription_set_external_id')
    end

    it 'sets correctly the effective date' do
      expect(csv_subscription_event.effective_date).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'sets event_order correctly' do
      expect(csv_subscription_event.event_order).to eq(1000)
    end

    it 'sets invoice_external_id correctly' do
      expect(csv_subscription_event.invoice_external_id).to eq(12_345)
    end

    it 'returns the correct headers' do
      expect(described_class.headers)
        .to eq(['External ID', 'Subscription set external ID', 'Subscription external ID', 'Customer external ID',
                'Plan external ID', 'Date', 'Effective Date', 'Event Type', 'Currency', 'Amount in Cents', 'Quantity', 'Retracted event ID', 'Event Order', 'Invoice external ID'].freeze)
    end
  end
end
