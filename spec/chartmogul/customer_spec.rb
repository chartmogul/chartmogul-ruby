# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Customer do
  let(:attrs) do
    {
      uuid: 'cus_adcd3-12345-123345',
      data_source_uuid: 'ds_123456',
      name: 'Test Customer',
      external_id: 'X1234',
      city: 'Berlin',
      state: 'BE',
      country: 'DE',
      zip: '10115',
      lead_created_at: Time.utc(2016, 10, 1).to_s,
      free_trial_started_at: Time.utc(2016, 10, 2).to_s
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Customer')
    end

    it 'sets the data_source_uuid attribute' do
      expect(subject.data_source_uuid).to eq('ds_123456')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('X1234')
    end

    it 'sets the city attribute' do
      expect(subject.city).to eq('Berlin')
    end

    it 'sets the state attribute' do
      expect(subject.state).to eq('BE')
    end

    it 'sets the country attribute' do
      expect(subject.country).to eq('DE')
    end
    it 'sets the zip attribute' do
      expect(subject.zip).to eq('10115')
    end

    it 'sets the lead_created_at attribute' do
      expect(subject.lead_created_at).to eq(Time.utc(2016, 10, 1).to_s)
    end

    it 'sets the free_trial_started_at attribute' do
      expect(subject.free_trial_started_at).to eq(Time.utc(2016, 10, 2).to_s)
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('cus_adcd3-12345-123345')
    end

    it 'sets the data_source_uuid attribute' do
      expect(subject.data_source_uuid).to eq('ds_123456')
    end

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Customer')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('X1234')
    end

    it 'sets the city attribute' do
      expect(subject.city).to eq('Berlin')
    end

    it 'sets the state attribute' do
      expect(subject.state).to eq('BE')
    end

    it 'sets the country attribute' do
      expect(subject.country).to eq('DE')
    end

    it 'sets the zip attribute' do
      expect(subject.zip).to eq('10115')
    end

    it 'sets the lead_created_at attribute' do
      expect(subject.lead_created_at).to eq(Time.utc(2016, 10, 1))
    end

    it 'sets the free_trial_started_at attribute' do
      expect(subject.free_trial_started_at).to eq(Time.utc(2016, 10, 2))
    end
  end

  describe '.find_by_external_id', vcr: true do
    context 'when external_id is provided' do
      it 'returns matching user if exists', uses_api: true do
        result = ChartMogul::Customer.find_by_external_id('X1234')
        expect(result).not_to be_nil
        expect(result.external_id).to eq(attrs[:external_id])
      end

      it 'returns nil if customer does not exist', uses_api: true do
        result = ChartMogul::Customer.find_by_external_id('nope')
        expect(result).to be_nil
      end
    end
  end

  describe 'API Interactions', vcr: true do
    let(:lead_created_at) { Time.utc(2016, 10, 1, 23, 55) }
    let(:free_trial_started_at) { Time.utc(2016, 10, 12, 11, 12) }

    it 'correctly interracts with the API', uses_api: true do
      ds = ChartMogul::DataSource.create!(name: 'Customer Test Data Source')

      customer = ChartMogul::Customer.create!(
        name: 'Test Customer',
        external_id: 'X1234',
        data_source_uuid: ds.uuid,
        email: 'test@example.com',
        city: 'Berlin',
        country: 'DE',
        lead_created_at: lead_created_at.to_s,
        free_trial_started_at: free_trial_started_at.to_s
      )

      customers = ChartMogul::Customer.all
      expect(customers.current_page).to eq(1)
      expect(customers.total_pages).to eq(1)
      expect(customers.page).to eq(1)
      expect(customers.per_page).to eq(200)
      expect(customers.has_more).to eq(false)
      expect(customers.size).to eq(1)
      expect(customers[0].uuid).not_to be_nil
      expect(customers[0].name).to eq('Test Customer')
      expect(customers[0].external_id).to eq('X1234')
      expect(customers[0].data_source_uuid).to eq(ds.uuid)
      expect(customers[0].email).to eq('test@example.com')
      expect(customers[0].city).to eq('Berlin')
      expect(customers[0].country).to eq('DE')
      expect(customers[0].lead_created_at).to eq(lead_created_at)
      expect(customers[0].free_trial_started_at).to eq(free_trial_started_at)
      expect(customers[0].billing_system_type).to eq('Import API')

      customer.destroy!

      customers = ChartMogul::Customer.all

      expect(customers.entries).to be_empty
    end

    it 'correctly handles a 422 response', uses_api: true do
      expect { ChartMogul::Customer.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

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

    it 'can page through search endpoint', uses_api: true do
      customers = described_class.search('adam@smith.com', page: 2, per_page: 1)
      expect(customers.first.email).to eq('adam@smith.com')
      expect(customers.has_more).to eq(false)
      expect(customers.per_page).to eq(1)
      expect(customers.page).to eq(2)
    end

    it 'raises 404 if no customers found', uses_api: true do
      expect { described_class.search('no@email.com') }.to raise_error(ChartMogul::NotFoundError)
    end

    it 'returns customer through retrieve endpoint', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      expect(customer).to be
    end

    it 'adds required tags', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.add_tags!('example', 'another-tag')
      expect(customer.tags).to match_array(%w[example another-tag])
    end

    it 'removes tags', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.remove_tags!('example')
      expect(customer.tags).to match_array(['another-tag'])
    end

    it 'adds custom attributes', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.add_custom_attributes!(
        { type: 'String', key: 'StringKey', value: 'String Value' },
        { type: 'Integer', key: 'integer_key', value: 1234 },
        { type: 'Timestamp', key: 'timestamp_key', value: Time.utc(2016, 0o1, 31) },
        type: 'Boolean', key: 'boolean_key', value: true
      )
      expect(customer.custom_attributes).to eq(
        StringKey: 'String Value',
        integer_key: 1234,
        timestamp_key: Time.utc(2016, 0o1, 31),
        boolean_key: true
      )
    end

    it 'updates custom attributes', uses_api: true do
      customer = described_class.retrieve('cus_07393ece-aab1-4255-8bcd-0ef11e24b047')
      customer.update_custom_attributes!(
        StringKey: 'Another String Value',
        integer_key: 5678,
        timestamp_key: Time.utc(2016, 0o2, 1),
        boolean_key: false
      )
      expect(customer.custom_attributes).to eq(
        StringKey: 'Another String Value',
        integer_key: 5678,
        timestamp_key: Time.utc(2016, 0o2, 1),
        boolean_key: false
      )
    end

    it 'respects camel case for all customers endpoint', uses_api: true do
      customer_with_camel_case = described_class.all(per_page: 10).first

      expect(customer_with_camel_case.custom_attributes.key?(:String_key)).to be true
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
      customer.lead_created_at = Time.utc(2016, 1, 1, 14, 30)
      customer.free_trial_started_at = Time.utc(2016, 2, 2, 22, 40)
      customer.attributes[:tags] = [:wurst]
      customer.attributes[:custom][:meinung] = [:lecker]

      customer.update!

      updated_customer = described_class.retrieve(customer_uuid)
      expect(updated_customer.name).to eq 'Currywurst'
      expect(updated_customer.email).to eq 'curry@wurst.com'
      expect(updated_customer.address).to eq(country: 'Germany', state: 'New York', city: 'Berlin', address_zip: nil)
      expect(updated_customer.attributes[:tags]).to eq ['wurst']
      expect(updated_customer.attributes[:custom][:meinung]).to eq ['lecker']
    end

    it 'updates customer using class method', uses_api: true, match_requests_on: [:method, :uri, :body] do
      customer_uuid = 'cus_a29bbcb6-43ed-11e9-9bff-a3a747d175b1'

      updated_customer = described_class.update!(customer_uuid, {
        email: 'curry@example.com',
        company: 'Curry 42',
        country: 'IN',
        state: 'NY',
        city: 'Berlin',
        free_trial_started_at: Time.utc(2020, 2, 2, 22, 40),
        attributes: {
          custom: {
            company_size: 'just me'
          },
          tags: ['foobar']
        }
      })

      expect(updated_customer.uuid).to eq customer_uuid
      expect(updated_customer.name).to eq 'Currywurst'
      expect(updated_customer.email).to eq 'curry@example.com'
      expect(updated_customer.address).to eq(country: 'India', state: 'New York', city: 'Berlin', address_zip: nil)
      expect(updated_customer.attributes[:tags]).to eq ['foobar']
      expect(updated_customer.attributes[:custom][:company_size]).to eq 'just me'
    end

    it 'raises 422 for update with invalid data', uses_api: true do
      customer_uuid = 'cus_782b0716-a728-11e6-8eab-a7d0e8cd5c1e'
      customer = described_class.retrieve(customer_uuid)

      customer.email = 'schnitzel.com'

      error_message = "The Customer could not be created or updated. (HTTP Status: 422)\n"\
        'Response: {"code":422,"message":"The value provided does not appear to be '\
        'a valid email address.","param":"email"}'

      expect do
        customer.update!
      end.to raise_error(ChartMogul::ResourceInvalidError, error_message)
    end

    it 'raises 401 if invalid credentials', uses_api: true do
      error_message = "No valid API key provided (HTTP Status: 401)\n"\
        'Response: {"code":401,"message":"No valid API key provided","param":null}'
      expect do
        described_class.all(per_page: 10)
      end.to raise_error(ChartMogul::UnauthorizedError, error_message)
    end
  end
end
