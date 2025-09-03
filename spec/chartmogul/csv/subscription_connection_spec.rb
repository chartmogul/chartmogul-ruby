# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::SubscriptionConnection do
  describe '#initialize' do
    subject(:connection) do
      described_class.new(
        primary_subscription_external_id: 'sub-1',
        primary_subscription_activation_number: 1,
        connected_subscription_external_id: 'sub-2',
        connected_subscription_activation_number: 2,
        primary_billing_connector_id: 123,
        primary_customer_external_id: 'cus-1',
        connected_billing_connector_id: 456,
        connected_customer_external_id: 'cus-2'
      )
    end

    it 'sets correctly all attributes' do
      expect(connection.primary_subscription_external_id).to eq('sub-1')
      expect(connection.primary_subscription_activation_number).to eq(1)
      expect(connection.connected_subscription_external_id).to eq('sub-2')
      expect(connection.connected_subscription_activation_number).to eq(2)
      expect(connection.primary_billing_connector_id).to eq(123)
      expect(connection.primary_customer_external_id).to eq('cus-1')
      expect(connection.connected_billing_connector_id).to eq(456)
      expect(connection.connected_customer_external_id).to eq('cus-2')
    end

    it 'returns the correct headers' do
      expect(described_class.headers)
        .to eq(
          [
            'Primary Subscription ID',
            'Primary Billing Connector ID',
            'Connected Subscription ID',
            'Connected Billing Connector ID'
          ]
        )
    end
  end
end
