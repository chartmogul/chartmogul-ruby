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
        country_id: 'FR',
        address_zip: '75002',
        email: 'john.doe@example.com',
        description: 'N/A',
        attributes: {custom: [{ type: 'Integer', key: 'integer_key', value: 1234 }]}
      )
    end

    it 'sets correctly the customer external ID' do
      expect(csv_customer.external_id).to eq('customer_external_id')
    end

    it 'sets correctly the country' do
      expect(csv_customer.country_id).to eq('FR')
    end

    it 'sets correctly the description' do
      expect(csv_customer.description).to eq('N/A')
    end

    it 'sets correctly the lead created at' do
      expect(csv_customer.lead_created_at).to eq(Time.new(2020, 8, 24, 8, 22, 15))
    end

    it 'sets correctly the attributes' do
      expect(csv_customer.attributes).to eq({custom: [{ type: 'Integer', key: 'integer_key', value: 1234 }]})
    end

    it 'returns the correct headers' do
      expect(described_class.headers)
        .to eq(['Name', 'Email', 'Company', 'Country', 'State', 'City', 'Zip', 'External ID', 'Lead created at', 'Free trial started at', 'Attributes'])
    end
  end
end
