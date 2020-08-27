# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Invoice do
  describe '#initialize' do
    subject(:csv_invoice) do
      described_class.new(
        customer_external_id: 'customer_id',
        external_id: 'invoice_id',
        date: Time.new(2020, 8, 24, 8, 22, 15)
      )
    end

    it 'sets correctly the customer external ID' do
      expect(csv_invoice.customer_external_id).to eq('customer_id')
    end

    it 'sets correctly the external ID' do
      expect(csv_invoice.external_id).to eq('invoice_id')
    end

    it 'sets correctly the date' do
      expect(csv_invoice.date).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'returns a struct' do
      expect(csv_invoice).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(['Customer external ID', 'Invoice external ID', 'Invoiced date', 'Due date', 'Currency'])
    end
  end
end
