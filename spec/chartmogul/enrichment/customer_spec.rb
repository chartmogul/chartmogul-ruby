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
      expect(customers.has_more).to eq(false)
      expect(customers.per_page).to eq(200)
      expect(customers.page).to eq(1)
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

    it 'updates customer', uses_api: true do
      customer_uuid = 'cus_782b0716-a728-11e6-8eab-a7d0e8cd5c1e'
      customer = described_class.retrieve(customer_uuid)

      customer.name = 'Currywurst'
      customer.email = 'curry@wurst.com'
      customer.company = 'Curry 36'
      customer.country = 'DE'
      customer.state = 'NY'
      customer.city = 'Berlin'
      customer.lead_created_at = Time.utc(2016,1,1,14,30)
      customer.free_trial_started_at = Time.utc(2016,2,2,22,40)
      customer.attributes[:tags] = [:wurst]
      customer.attributes[:custom][:meinung] = [:lecker]

      customer.update!

      updated_customer = described_class.retrieve(customer_uuid)
      expect(updated_customer.name).to eq 'Currywurst'
      expect(updated_customer.email).to eq 'curry@wurst.com'
      expect(updated_customer.address).to eq({ country: 'Germany', state: 'New York', city: 'Berlin', address_zip: nil})
      expect(updated_customer.attributes[:tags]).to eq ['wurst']
      expect(updated_customer.attributes[:custom][:meinung]).to eq ['lecker']
    end

    it 'raises 422 for update with invalid data', uses_api: true do
      customer_uuid = 'cus_782b0716-a728-11e6-8eab-a7d0e8cd5c1e'
      customer = described_class.retrieve(customer_uuid)

      customer.email = 'schnitzel.com'
      expect do
        customer.update!
      end.to raise_error(ChartMogul::ResourceInvalidError, 'The Customer could not be created or updated.')
    end

    it 'raises 401 if invalid credentials', uses_api: true do
      expect do
        described_class.all(per_page: 10)
      end.to raise_error(ChartMogul::UnauthorizedError, 'No valid API key provided')
    end
  end
end
