# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Customer do
  let(:attrs) do
    {
      uuid: 'cus_23740208-2c7e-11ee-9ea2-ffd2435982bb',
      data_source_uuid: 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46',
      name: 'Test Customer',
      email: 'customer@example.com',
      company: 'ChartMogul',
      external_id: 'cus_001',
      city: 'Berlin',
      state: 'BE',
      country: 'DE',
      zip: '10115',
      status: 'Active',
      lead_created_at: Time.utc(2016, 10, 1).to_s,
      free_trial_started_at: Time.utc(2016, 10, 2).to_s,
      owner: 'owner@chartmogul.com',
      custom: { Toggle: false },
      website_url: 'example.com'
    }
  end
  let(:customer_uuid) { 'cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b' }
  let(:data_source_uuid) { 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46' }
  let(:customer_note_uuid) { 'note_23e5e234-94e7-11ee-b12d-33351b909dc1'}
  let(:customer_note_attrs) do
    {
      uuid: 'cus_58f81bdc-94e6-11ee-ba3e-63f79c1ac982',
      data_source_uuid: 'ds_a628a2ae-7451-11eb-a2cf-ab1ab88dd733'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the right attributes' do
      expect(subject).to have_attributes(
        uuid: nil,
        data_source_uuid: 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46',
        name: 'Test Customer',
        email: 'customer@example.com',
        company: 'ChartMogul',
        external_id: 'cus_001',
        country: 'DE',
        state: 'BE',
        city: 'Berlin',
        zip: '10115',
        lead_created_at: Time.utc(2016, 10, 1).to_s,
        free_trial_started_at: Time.utc(2016, 10, 2).to_s,
        owner: 'owner@chartmogul.com',
        status: nil,
        website_url: 'example.com'
      )
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets the right attributes' do
      expect(subject).to have_attributes(
        uuid: 'cus_23740208-2c7e-11ee-9ea2-ffd2435982bb',
        data_source_uuid: 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46',
        name: 'Test Customer',
        email: 'customer@example.com',
        company: 'ChartMogul',
        external_id: 'cus_001',
        country: 'DE',
        state: 'BE',
        city: 'Berlin',
        zip: '10115',
        lead_created_at: Time.utc(2016, 10, 1),
        free_trial_started_at: Time.utc(2016, 10, 2),
        owner: 'owner@chartmogul.com',
        status: 'Active',
        website_url: 'example.com'
      )
    end
  end

  describe '.find_by_external_id', uses_api: true, vcr: true do
    it 'returns matching user if exists' do
      result = ChartMogul::Customer.find_by_external_id('test_cus_ext_id')
      expect(result.external_id).to eq('test_cus_ext_id')
    end

    it 'returns nil if customer does not exist' do
      result = ChartMogul::Customer.find_by_external_id('unknown')
      expect(result).to be_nil
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    let(:lead_created_at) { Time.utc(2015, 11, 1) }
    let(:free_trial_started_at) { Time.utc(2015, 11, 17, 01, 20) }

    it 'retrieves the customer correctly' do
      customer = described_class.retrieve(customer_uuid)

      expect(customer).to have_attributes(
        uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        email: 'customer@example.com',
        external_id: 'cus_004',
        website_url: 'https://chartmogul.com'
      )
    end

    it 'creates the customer correctly' do
      attributes = {
        data_source_uuid: data_source_uuid,
        external_id: 'cus_007',
        name: 'New Customer',
        email: 'new_customer@example.com',
        owner: 'bruno+chartmogultest@chartmogul.com',
        city: 'Berlin',
        website_url: 'https://chartmogul.com'
      }
      customer = described_class.create!(**attributes)
      expect(customer).to have_attributes(
        uuid: 'cus_a4680a9c-76a4-11ee-83ab-d3b9aabc7f00', **attributes
      )
    end

    it 'updates the customer correctly with the instance method' do
      customer_uuid = 'cus_a4680a9c-76a4-11ee-83ab-d3b9aabc7f00'
      customer = described_class.retrieve(customer_uuid)

      customer.name = 'Currywurst'
      customer.email = 'curry@wurst.com'
      customer.company = 'Curry 36'
      customer.country = 'DE'
      customer.state = 'NY'
      customer.city = 'Berlin'
      customer.lead_created_at = Time.utc(2016, 1, 1, 14, 30)
      customer.free_trial_started_at = Time.utc(2016, 2, 2, 22, 40)
      customer.website_url = 'https://chartmogul.com'
      customer.attributes = {}.tap do |att|
        att[:tags] = [:wurst]
        att[:custom] = { Toggle: true }
      end

      updated_customer = customer.update!
      expect(updated_customer).to have_attributes(
        name: 'Currywurst',
        email: 'curry@wurst.com',
        attributes: {
          custom: { Toggle: true }, clearbit: {},
          tags: ["wurst"], stripe: {}
        },
        company: 'Curry 36'
      )
    end

    it 'updates customer correctly with the class method' do
      customer_uuid = 'cus_a4680a9c-76a4-11ee-83ab-d3b9aabc7f00'

      updated_customer = described_class.update!(customer_uuid, {
        email: 'customer_test@example.com',
        company: 'Curry 42',
        attributes: { custom: { Toggle: true } },
        name: 'Test Customer',
        website_url: 'https://example.co'
      })

      expect(updated_customer).to have_attributes(
        email: 'customer_test@example.com',
        company: 'Curry 42',
        name: 'Test Customer',
        website_url: 'https://example.co',
        attributes: {
          custom: { Toggle: true }, clearbit: {},
          tags: ["wurst"], stripe: {}
        }
      )
    end

    it 'destroys the customer correctly' do
      uuid_to_delete = 'cus_a4680a9c-76a4-11ee-83ab-d3b9aabc7f00'
      deleted_customer = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_customer).to eq(true)
    end

    it 'merges customers correctly with the class method' do
      from_uuid = 'cus_c10aa086-5298-11ee-82da-ebac6f7a03c3'
      into_uuid = 'cus_23740208-2c7e-11ee-9ea2-ffd2435982bb'

      customer_result = described_class.merge!(
        into_uuid: into_uuid, from_uuid: from_uuid
      )
      expect(customer_result).to eq(true)
    end

    it 'merges customers correctly with the instance method' do
      from_uuid = 'cus_2706d304-76b7-11ee-93d6-5b3d820d37cd'
      into_uuid = 'cus_23740208-2c7e-11ee-9ea2-ffd2435982bb'

      into_customer = described_class.retrieve(into_uuid)
      from_customer = described_class.retrieve(from_uuid)

      customer_result = from_customer.merge_into!(into_customer)
      expect(customer_result).to eq(true)
    end

    context 'with old pagination' do
      context 'when listing customers using #all' do
        let(:get_resources) { ChartMogul::Customers.all(per_page: 1, page: 3) }

        it_behaves_like 'raises deprecated param error'
      end

      context 'when listing customers using #search' do
        let(:get_resources) { described_class.search('gavin@example.com', page: 1, per_page: 1) }

        it_behaves_like 'raises deprecated param error'
      end
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAxNi0wMS0wMVQxMjowMDowMC4wMDAwMDAwMDBaJjExNDE2NzQ1MA=='
      end
      let(:next_cursor) do
        'MjAxNi0wMS0yNVQwMDowMDowMC4wMDAwMDAwMDBaJjExNDE2NzQ1MQ=='
      end

      it 'paginates correctly' do
        customers = ChartMogul::Customer.all(per_page: 1)
        expect(customers).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          page: 1, per_page: 1
        )
        expect(customers.first).to have_attributes(
          uuid: 'cus_23740208-2c7e-11ee-9ea2-ffd2435982bb'
        )

        next_customers = customers.next(per_page: 1)
        expect(next_customers).to have_attributes(
          cursor: next_cursor,
          has_more: true,
          size: 1
        )
        expect(next_customers.first).to have_attributes(
          uuid: 'cus_23c11cf0-2c7e-11ee-b2cd-fbfd681a34dd'
        )
      end

      it 'paginates the /search endpoint correctly' do
        customers = described_class.search('gavin@example.com', per_page: 1)
        expect(customers.first.email).to eq('gavin@example.com')
        expect(customers).to have_attributes(
          cursor: 'MjAxNi0wMS0yNVQwMDowMDowMC4wMDAwMDAwMDBaJjExNDE2NzQ1MQ==',
          has_more: false, page: 1, per_page: 1
        )
      end
    end

    it 'searches for customers correctly' do
      customers = described_class.search('gavin@example.com')
      expect(customers.first.email).to eq('gavin@example.com')
      expect(customers).to have_attributes(
        cursor: 'MjAxNi0wMS0yNVQwMDowMDowMC4wMDAwMDAwMDBaJjExNDE2NzQ1MQ==',
        has_more: false,
        per_page: 200,
        page: 1
      )
    end

    it 'raises a HTTP 404 if searching for customers does not find any' do
      expect { described_class.search('no@email.com') }.to raise_error(ChartMogul::NotFoundError)
    end

    it 'adds tags correctly' do
      attrs[:attributes] = {
        tags: ["auto-churned-delinquent-subscription", "merged-customer"],
        custom: {}
      }
      customer = described_class.new_from_json(attrs)
      updated_tags = customer.add_tags!('test-tag')
      expect(updated_tags).to eq(
        ["auto-churned-delinquent-subscription", "merged-customer", "test-tag"]
      )
    end

    it 'removes tags correctly' do
      attrs[:attributes] = {
        tags: ["auto-churned-delinquent-subscription", "merged-customer", "test-tag"],
        custom: {}
      }
      customer = described_class.new_from_json(attrs)
      updated_tags = customer.remove_tags!('test-tag')
      expect(updated_tags).to eq(["auto-churned-delinquent-subscription", "merged-customer"])
    end

    it 'adds custom attributes correctly' do
      attrs[:attributes] = { tags: [], custom: {} }
      customer = described_class.new_from_json(attrs)
      updated_attributes = customer.add_custom_attributes!(
        { type: 'String', key: 'StringKey', value: 'String Value' },
        { type: 'Integer', key: 'integer_key', value: 1234 },
        { type: 'Timestamp', key: 'timestamp_key', value: Time.utc(2016, 1, 31) },
        { type: 'Boolean', key: 'boolean_key', value: true }
      )
      expect(updated_attributes).to eq(
        StringKey: 'String Value',
        integer_key: 1234,
        timestamp_key: '2016-01-31T00:00:00.000Z',
        boolean_key: true
      )
    end

    it 'updates custom attributes correctly' do
      attrs[:attributes] = {
        tags: [],
        custom: {
          StringKey: 'String Value',
          integer_key: 1234,
          timestamp_key: '2016-01-31T00:00:00.000Z',
          boolean_key: true
        }
      }
      customer = described_class.new_from_json(attrs)
      updated_attributes = customer.update_custom_attributes!(
        StringKey: 'Another String Value',
        integer_key: 5678,
        timestamp_key: Time.utc(2016, 2, 1),
        boolean_key: false,
        Toggle: false
      )
      expect(updated_attributes).to eq(
        StringKey: 'Another String Value',
        integer_key: 5678,
        timestamp_key: '2016-02-01T00:00:00.000Z',
        boolean_key: false,
        Toggle: false
      )
    end

    it 'removes custom attributes correctly' do
      attrs[:attributes] = {
        tags: [],
        custom: {
          StringKey: 'Another String Value',
          integer_key: 5678,
          timestamp_key: '2016-02-01T00:00:00.000Z',
          boolean_key: false
        }
      }
      customer = described_class.new_from_json(attrs)
      updated_attributes = customer.remove_custom_attributes!(
        :StringKey, :integer_key, :timestamp_key, :boolean_key
      )
      expect(updated_attributes).to eq({})
    end

    it 'lists the contacts belonging to the customer correctly' do
      cursor = 'MjAyMy0xMC0zMFQwMToxNDoxNi4zNzIzODUwMDBaJmNvbl9'\
               'hNGZiOWI2NC03NmMxLTExZWUtOWZmOC1jYjBiYTIzODQ1MjM='

      contacts = described_class.new_from_json(attrs).contacts
      expect(contacts.entries.size).to eq(1)
      expect(contacts.has_more).to eq(false)
      expect(contacts.cursor).not_to be_nil
    end

    it 'creates a contact belonging to the customer correctly' do
      customer = described_class.new_from_json(attrs)
      new_contact = customer.create_contact(
        data_source_uuid: customer.data_source_uuid,
        email: 'new_contact@example.com'
      )
      expect(new_contact.email).to eq('new_contact@example.com')
    end

    it 'creates a note belonging to the customer correctly' do
      new_note = described_class.new_from_json({
        uuid: customer_note_attrs[:uuid],
        data_source_uuid: customer_note_attrs[:data_source_uuid],
      }).create_note(
        text: 'This is a call',
        type: 'call',
        author_email: 'soeun+staff@chartmogul.com',
      )
      expect(new_note.text).to eq('This is a call')
      expect(new_note.type).to eq('call')
      expect(new_note.author).to eq('Soeun Lee[staff-user-2] (soeun+staff@chartmogul.com)')

    end

    it 'lists the notes belonging to the customer correctly' do
      notes = described_class.new_from_json({
        uuid: customer_note_attrs[:uuid],
        data_source_uuid: customer_note_attrs[:data_source_uuid],
      }).notes
      expect(notes.entries.size).to eq(1)
      expect(notes.has_more).to eq(false)
      expect(notes.cursor).not_to be_nil
    end

    it 'lists the invoices belonging to the customer correctly' do
      invoices = described_class.new_from_json(attrs).invoices
      expect(invoices.entries.size).to eq(2)
      expect(invoices.has_more).to eq(false)
      expect(invoices.cursor).not_to be_nil
    end

    it 'lists the subscriptions belonging to the customer correctly' do
      subs = described_class.new_from_json(attrs).subscriptions
      expect(subs.entries.size).to eq(2)
      expect(subs.has_more).to eq(false)
      expect(subs.cursor).not_to be_nil
    end
  end
end
