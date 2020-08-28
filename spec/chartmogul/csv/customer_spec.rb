# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Customer do
  describe '#initialize' do
    subject(:csv_customer) do
      described_class.new(
        name: 'John Doe',
        external_id: 'customer_external_id',
        lead_created_at: Time.new(2020, 8, 24, 8, 22, 15),
        free_trial_started_at: Time.new(2020, 8, 26, 9, 32, 17),
        country: 'FR',
        zip: '75002',
        email: 'john.doe@example.com'
      )
    end

    it 'sets correctly the customer external ID' do
      expect(csv_customer.external_id).to eq('customer_external_id')
    end

    it 'sets correctly the country' do
      expect(csv_customer.country).to eq('FR')
    end

    it 'sets correctly the lead created at' do
      expect(csv_customer.lead_created_at).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'returns a struct' do
      expect(csv_customer).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(['Name', 'Email', 'Company', 'Country', 'State', 'City', 'Zip', 'External ID', 'Lead created at', 'Free trial started at'])
    end
  end
end
