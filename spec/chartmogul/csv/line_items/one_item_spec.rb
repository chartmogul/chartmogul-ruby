# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::LineItems::OneTime do
  describe '#initialize' do
    subject(:csv_one_time) do
      described_class.new(
        subscription_external_id: 'subscription_id',
        invoice_external_id: 'invoice_id',
        service_period_start: Time.new(2020, 8, 24, 8, 22, 15),
        service_period_end: Time.new(2020, 9, 24, 8, 22, 14),
        amount_in_cents: 100_00,
        transaction_fees_in_cents: 3_00,
        prorated: false,
        quantity: 1,
        transaction_fees_currency: 'EUR'
      )
    end

    it 'sets correctly the type' do
      expect(csv_one_time.type).to eq('one_time')
    end

    it 'sets correctly the amount' do
      expect(csv_one_time.amount_in_cents).to eq(100_00)
    end

    it 'sets correctly the transaction fees' do
      expect(csv_one_time.transaction_fees_in_cents).to eq(300)
    end

    it 'sets correctly the transaction fees currency' do
      expect(csv_one_time.transaction_fees_currency).to eq('EUR')
    end

    it 'returns the correct headers' do
      expect(described_class.headers).to eq(
        [
          'Invoice external ID',
          'External ID',
          'Subscription external ID',
          'Subscription set external ID',
          'Type',
          'Amount in cents',
          'Plan',
          'Service period start',
          'Service period end',
          'Quantity',
          'Proration',
          'Discount code',
          'Discount amount',
          'Tax amount',
          'Description',
          'Transaction fee',
          'Account Code',
          'Transaction fees currency',
          'Discount description',
          'Balance transfer'
        ]
      )
    end
  end
end
