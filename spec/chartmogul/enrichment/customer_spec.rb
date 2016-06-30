require 'spec_helper'

describe ChartMogul::Enrichment::Customer do
  describe 'API Interactions', vcr: true do
    it 'returns all customers through list all endpoint', uses_api: true do
      customers = described_class.all(per_page: 10)
      expect(customers).to be_any
    end

    it 'returns right customers through search endpoint', uses_api: true do
      customers = described_class.search('adam@smith.com')
      expect(customers.first.email).to eq('adam@smith.com')
    end

    it 'raises 404 if no customers found', uses_api: true do
      expect{described_class.search('no@email.com')}.to raise_error(ChartMogul::NotFoundError)
    end

    it 'returns customer through retrieve endpoint', uses_api: true do
      customer = described_class.retrieve(20268060)
      expect(customer).to be
    end

    it 'adds required tags', uses_api: true do
      customer = described_class.retrieve(20268060)
      customer.add_tags!('example', 'another-tag')
      expect(customer.tags).to match_array(['example', 'another-tag'])
    end

    it 'removes tags', uses_api: true do
      customer = described_class.retrieve(20268060)
      customer.remove_tags!('example')
      expect(customer.tags).to match_array(['another-tag'])
    end

    it 'adds custom attributes', uses_api: true do
      customer = described_class.retrieve(20268060)
      customer.add_custom_attributes!(
        { type: "String", key: "string_key", value: "String Value" },
        { type: "Integer", key: "integer_key", value: 1234 },
        { type: "Timestamp", key: "timestamp_key", value: Time.utc(2016,01,31) },
        { type: "Boolean", key: "boolean_key", value: true }
      )
      expect(customer.custom_attributes).to eq(
        string_key: "String Value",
        integer_key: 1234,
        timestamp_key: Time.utc(2016,01,31),
        boolean_key: true
      )
    end

    it 'updates custom attributes', uses_api: true do
      customer = described_class.retrieve(20268060)
      customer.update_custom_attributes!(
        string_key: "Another String Value",
        integer_key: 5678,
        timestamp_key: Time.utc(2016,02,1),
        boolean_key: false
      )
      expect(customer.custom_attributes).to eq(
        string_key: "Another String Value",
        integer_key: 5678,
        timestamp_key: Time.utc(2016,02,1),
        boolean_key: false
      )
    end

    it 'removes custom attributes', uses_api: true do
      customer = described_class.retrieve(20268060)
      customer.remove_custom_attributes!(:string_key, :integer_key, :timestamp_key, :boolean_key)
      expect(customer.custom_attributes).to eq({})
    end
  end
end
