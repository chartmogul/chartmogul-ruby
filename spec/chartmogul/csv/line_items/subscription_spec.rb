# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::LineItems::Subscription do
  describe '#initialize' do
    subject(:csv_subscription) do
      described_class.new(
        subscription_external_id: 'subscription_id',
        subscription_set_external_id: 'subscription_set_id',
        invoice_external_id: 'invoice_id',
        service_period_start: Time.new(2020, 8, 24, 8, 22, 15),
        service_period_end: Time.new(2020, 9, 24, 8, 22, 14),
        amount_in_cents: 100_00,
        transaction_fees_in_cents: 3_00,
        prorated: false,
        quantity: 1
      )
    end

    it 'sets correctly the type' do
      expect(csv_subscription.type).to eq('subscription')
    end

    it 'sets correctly the amount in cents' do
      expect(csv_subscription.amount_in_cents).to eq(100_00)
    end

    it 'sets correctly the transaction fees in cents' do
      expect(csv_subscription.transaction_fees_in_cents).to eq(300)
    end

    it 'returns a struct' do
      expect(csv_subscription).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(
        %w[
          Invoice\ external\ ID
          External\ ID
          Subscription\ external\ ID
          Subscription\ set\ external\ ID
          Type
          Amount\ in\ cents
          Plan
          Service\ period\ start
          Service\ period\ end
          Quantity
          Proration
          Discount\ code
          Discount\ amount
          Tax\ amount
          Description
          Transaction\ fee
          Account\ Code
        ]
      )
    end
  end
end
