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
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      expect(customer).to be
    end

    it 'adds required tags', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.add_tags!('example', 'another-tag')
      expect(customer.tags).to match_array(['example', 'another-tag'])
    end

    it 'removes tags', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.remove_tags!('example')
      expect(customer.tags).to match_array(['another-tag'])
    end

    it 'adds custom attributes', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
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
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
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
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.remove_custom_attributes!(:string_key, :integer_key, :timestamp_key, :boolean_key)
      expect(customer.custom_attributes).to eq({})
    end

    it 'merges customers', uses_api: true do
      from_uuid = 'cus_35da5436-a730-11e6-a5a0-d32f2a781b50'
      into_uuid = 'cus_fc5451ee-a72f-11e6-9019-3b1a0ecf3c73'

      from_customer = described_class.retrieve(from_uuid)
      into_customer = described_class.retrieve(into_uuid)

      expect(from_customer.merge_into!(into_customer)).to eq(true)

      expect do
        described_class.retrieve(from_uuid)
      end.to raise_error ChartMogul::NotFoundError

      merged_customer = described_class.retrieve(into_uuid)
      expect(merged_customer.attributes[:tags]).to eq ['merged-customer']
    end
  end
end
