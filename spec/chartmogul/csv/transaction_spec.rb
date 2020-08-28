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
        date: Time.new(2020, 8, 24, 8, 22, 15)
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
      expect(csv_transaction.date).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'returns a struct' do
      expect(csv_transaction).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(['Invoice external ID', 'External ID', 'Type', 'Result', 'Date'])
    end
  end
end
