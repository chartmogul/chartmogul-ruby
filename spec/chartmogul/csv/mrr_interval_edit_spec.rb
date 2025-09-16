# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::MrrIntervalEdit do
  describe '#initialize' do
    subject(:mrr_edit) do
      described_class.new(
        account_id: 1,
        billing_connector_id: 1,
        customer_external_id: 'cus-123',
        subscription_external_id: 'sub-456',
        subscription_activation_number: 1,
        interval_start_date: Time.new(2025, 9, 12),
        edited_mrr: 1000,
        timestamp: Time.new(2025, 9, 12, 12),
        auth_user_id: 1,
        email: 'user@example.com',
        edit_type: 'manual_adjustment'
      )
    end

    it 'sets correctly all attributes' do
      expect(mrr_edit.account_id).to eq(1)
      expect(mrr_edit.billing_connector_id).to eq(1)
      expect(mrr_edit.customer_external_id).to eq('cus-123')
      expect(mrr_edit.subscription_external_id).to eq('sub-456')
      expect(mrr_edit.subscription_activation_number).to eq(1)
      expect(mrr_edit.interval_start_date).to eq(Time.new(2025, 9, 12))
      expect(mrr_edit.edited_mrr).to eq(1000)
      expect(mrr_edit.timestamp).to eq(Time.new(2025, 9, 12, 12))
      expect(mrr_edit.auth_user_id).to eq(1)
      expect(mrr_edit.email).to eq('user@example.com')
      expect(mrr_edit.edit_type).to eq('manual_adjustment')
    end

    it 'returns the correct headers' do
      expect(described_class.headers)
        .to eq(
          [
            'Account ID',
            'Billing Connector ID',
            'Customer External ID',
            'Subscription External ID',
            'Subscription Activation Number',
            'Interval Start Date',
            'Edited MRR',
            'Timestamp',
            'Auth User ID',
            'Email',
            'Edit Type'
          ]
        )
    end
  end
end
