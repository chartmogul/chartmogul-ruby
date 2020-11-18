# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Transaction do
  describe '#initialize' do
    subject(:csv_transaction) do
      described_class.new(
        invoice_external_id: 'invoice_id',
        external_id: 'transaction_id',
        type: 'payment',
        result: 'successful',
        transacted_at: Time.new(2020, 8, 24, 8, 22, 15)
      )
    end

    it 'sets correctly the invoice id name' do
      expect(csv_transaction.invoice_external_id).to eq('invoice_id')
    end

    it 'sets correctly the external ID' do
      expect(csv_transaction.external_id).to eq('transaction_id')
    end

    it 'sets correctly the interval count' do
      expect(csv_transaction.type).to eq('payment')
    end

    it 'sets correctly the result' do
      expect(csv_transaction.result).to eq('successful')
    end

    it 'sets correctly the transaction date' do
      expect(csv_transaction.transacted_at).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'returns the correct headers' do
      expect(described_class.headers).to eq(['Invoice external ID', 'External ID', 'Type', 'Result', 'Date'])
    end
  end
end
