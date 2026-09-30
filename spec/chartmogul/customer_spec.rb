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
  let(:customer_note_uuid) { 'note_23e5e234-94e7-11ee-b12d-33351b909dc1' }
  let(:customer_note_attrs) do
    {
      uuid: 'cus_58f81bdc-94e6-11ee-ba3e-63f79c1ac982',
      data_source_uuid: 'ds_a628a2ae-7451-11eb-a2cf-ab1ab88dd733'
    }
  end
  let(:opportunity_attrs) do
    {
      uuid: 'cus_4e49211a-df7b-11ee-8949-df3c4571686f',
      data_source_uuid: 'ds_7ed73928-dd2a-11ee-a144-bf5bc12d16ea'
    }
  end
  let(:task_attrs) do
    {
      uuid: 'cus_9c8cc2bd-762e-4d93-ae34-1cfb53a53f64',
      data_source_uuid: 'ds_f112194c-1ffd-11f0-a22d-13b7784499e0'
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
    let(:free_trial_started_at) { Time.utc(2015, 11, 17, 1, 20) }

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
          tags: ['wurst'], stripe: {}
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
          tags: ['wurst'], stripe: {}
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

    it 'unmerges correctly with the class method' do
      customer_uuid = 'cus_cd9e5f29-6299-40e5-b343-0bd1ed228b4f'
      external_id = 'cus_O075O8NH0LrtG8'
      data_source_uuid = 'ds_788ec6ae-dd51-11ee-bd46-a3ec952dc041'

      unmerge_result = described_class.unmerge!(
        customer_uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        external_id: external_id,
        move_to_new_customer: []
      )
      expect(unmerge_result).to eq(true)
    end

    it 'unmerges correctly with the instance method' do
      customer_uuid = 'cus_cd9e5f29-6299-40e5-b343-0bd1ed228b4f'
      from_customer = described_class.retrieve(customer_uuid)
      external_id = 'cus_O075O8NH0LrtG8'
      data_source_uuid = 'ds_788ec6ae-dd51-11ee-bd46-a3ec952dc041'

      unmerge_result = from_customer.unmerge!(
        data_source_uuid: data_source_uuid,
        external_id: external_id,
        move_to_new_customer: []
      )
      expect(unmerge_result).to eq(true)
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

    it 'retrieves the customer attributes correctly' do
      result = described_class.retrieve_attributes(customer_uuid)
      expect(result[:tags]).to eq(%w[managed important])
      expect(result[:custom]).to eq(CAC: 213, utmCampaign: 'social media 1')
    end

    it 'retrieves the customer attributes correctly with the instance method' do
      customer = described_class.new_from_json(attrs)
      result = customer.retrieve_attributes
      expect(result[:tags]).to eq(%w[managed important])
      expect(result[:custom]).to eq(CAC: 213, utmCampaign: 'social media 1')
    end

    it 'adds tags by email correctly' do
      result = described_class.add_tags_by_email!('customer@example.com', 'important', 'Prio1')
      expect(result[:entries]).to be_an(Array)
      expect(result[:entries].first[:attributes][:tags]).to include('important', 'Prio1')
    end

    it 'adds custom attributes by email correctly' do
      result = described_class.add_custom_attributes_by_email!(
        'customer@example.com',
        { type: 'String', key: 'channel', value: 'Facebook' },
        { type: 'Integer', key: 'age', value: 8 }
      )
      expect(result[:entries]).to be_an(Array)
      expect(result[:entries].first[:attributes][:custom]).to include(channel: 'Facebook', age: 8)
    end

    it 'adds tags correctly' do
      attrs[:attributes] = {
        tags: %w[auto-churned-delinquent-subscription merged-customer],
        custom: {}
      }
      customer = described_class.new_from_json(attrs)
      updated_tags = customer.add_tags!('test-tag')
      expect(updated_tags).to eq(
        %w[auto-churned-delinquent-subscription merged-customer test-tag]
      )
    end

    it 'removes tags correctly' do
      attrs[:attributes] = {
        tags: %w[auto-churned-delinquent-subscription merged-customer test-tag],
        custom: {}
      }
      customer = described_class.new_from_json(attrs)
      updated_tags = customer.remove_tags!('test-tag')
      expect(updated_tags).to eq(%w[auto-churned-delinquent-subscription merged-customer])
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
                                                 data_source_uuid: customer_note_attrs[:data_source_uuid]
                                               }).create_note(
                                                 text: 'This is a call',
                                                 type: 'call',
                                                 author_email: 'soeun+staff@chartmogul.com'
                                               )
      expect(new_note.text).to eq('This is a call')
      expect(new_note.type).to eq('call')
      expect(new_note.author).to eq('Soeun Lee[staff-user-2] (soeun+staff@chartmogul.com)')
    end

    it 'lists the notes belonging to the customer correctly' do
      notes = described_class.new_from_json({
                                              uuid: customer_note_attrs[:uuid],
                                              data_source_uuid: customer_note_attrs[:data_source_uuid]
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

    it 'creates a opportunity belonging to the customer correctly' do
      attrs = { owner: 'kamil+pavlicko@chartmogul.com',
                pipeline: 'New Business',
                pipeline_stage: 'Discovery',
                estimated_close_date: '2024-03-30',
                currency: 'USD',
                amount_in_cents: 200_000,
                type: 'one-time',
                forecast_category: 'best_case',
                win_likelihood: 30,
                custom: [{ key: 'from_campaign', value: true }] }

      new_opportunity = described_class.new_from_json({
                                                        uuid: opportunity_attrs[:uuid],
                                                        data_source_uuid: opportunity_attrs[:data_source_uuid]
                                                      }).create_opportunity(attrs)
      expect(new_opportunity).to have_attributes(**attrs.merge(custom: { from_campaign: true }))
    end

    it 'lists the opportunities belonging to the customer correctly' do
      opportunities = described_class.new_from_json({
                                                      uuid: opportunity_attrs[:uuid],
                                                      data_source_uuid: opportunity_attrs[:data_source_uuid]
                                                    }).opportunities
      expect(opportunities.entries.size).to eq(1)
      expect(opportunities.has_more).to eq(false)
      expect(opportunities.cursor).not_to be_nil
    end

    it 'creates a task belonging to the customer correctly' do
      attrs = { task_details: 'This is some task details text.',
                assignee: 'keith+test1@chartmogul.com',
                due_date: '2025-04-30T00:00:00Z',
                completed_at: nil }

      new_task = described_class.new_from_json({
                                                 uuid: task_attrs[:uuid],
                                                 data_source_uuid: task_attrs[:data_source_uuid]
                                               }).create_task(attrs)
      expect(new_task.task_details).to eq('This is some task details text.')
      expect(new_task.assignee).to eq('keith+test1@chartmogul.com')
      expect(new_task.due_date).to eq('2025-04-30T00:00:00.000Z')
      expect(new_task.completed_at).to be_nil
    end

    it 'lists the tasks belonging to the customer correctly' do
      tasks = described_class.new_from_json({
                                              uuid: task_attrs[:uuid],
                                              data_source_uuid: task_attrs[:data_source_uuid]
                                            }).tasks
      expect(tasks.entries.size).to eq(1)
      expect(tasks.has_more).to eq(false)
      expect(tasks.cursor).not_to be_nil
    end
  end

  describe 'Overrides' do
    let(:customer_uuid) { 'cus_3436cdf0-bcb3-11f1-859f-6380207336a0' }
    let(:data_source_uuid) { 'ds_27917f42-bcb2-11f1-b389-43b0d7aec832' }
    it 'serializes overrides for write' do
      customer = described_class.new(
        data_source_uuid: data_source_uuid,
        company: 'Pinned Co',
        overrides: { company: true, attributes: { custom: { MyChannel: true } } }
      )

      expect(customer.serialize_for_write[:overrides]).to eq(
        company: true, attributes: { custom: { MyChannel: true } }
      )
    end

    it_behaves_like 'retrieve with query params', 'cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b',
                    { with_overrides: true, attributes_with_history: 'company,custom.MyChannel' },
                    <<-JSON,
                    {
                      "uuid": "cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b",
                      "overrides": {
                        "company": true,
                        "attributes": { "custom": { "MyChannel": true } }
                      },
                      "historical_values": {
                        "company": [
                          { "value": "Pinned Co", "update_performed_at": "2026-09-01T10:00:00Z", "update_performed_by": "user@example.com", "initial": false },
                          { "value": "Old Co", "update_performed_at": null, "update_performed_by": null, "initial": true }
                        ],
                        "attributes": {
                          "custom": {
                            "MyChannel": [
                              { "value": "Facebook", "update_performed_at": "2026-09-02T10:00:00Z", "update_performed_by": "user@example.com", "initial": false }
                            ]
                          }
                        }
                      }
                    }
                    JSON
                    lambda { |customer|
                      expect(customer.overrides).to eq(company: true, attributes: { custom: { MyChannel: true } })
                      expect(customer.historical_values[:company].first).to eq(
                        value: 'Pinned Co',
                        update_performed_at: '2026-09-01T10:00:00Z',
                        update_performed_by: 'user@example.com',
                        initial: false
                      )
                      expect(customer.historical_values[:attributes][:custom].keys).to eq([:MyChannel])
                    }

    def request_double
      req = double('request', headers: {})
      allow(req).to receive(:body=) { |value| @sent_body = value }
      req
    end

    def stub_api_request(method, path, response_body)
      connection = double('connection')
      allow(described_class).to receive(:connection).and_return(connection)
      allow(connection).to receive(method) do |request_path, &req_block|
        req_block.call(request_double)
        expect(request_path).to eq(path)
        double('response', body: response_body)
      end
    end

    def sent_body
      JSON.parse(@sent_body)
    end

    context 'with the pre-overrides call forms' do
      it 'sends brace-less add_custom_attributes! args as custom attributes only' do
        customer = described_class.new_from_json(uuid: customer_uuid, attributes: { tags: [], custom: {} })
        stub_api_request(:post, "/v1/customers/#{customer_uuid}/attributes/custom",
                         '{"custom":{"MyChannel":"Facebook"}}')

        updated_attributes = customer.add_custom_attributes!(type: 'String', key: 'MyChannel', value: 'Facebook')

        expect(updated_attributes).to eq(MyChannel: 'Facebook')
        expect(sent_body).to eq('custom' => [{ 'type' => 'String', 'key' => 'MyChannel', 'value' => 'Facebook' }])
      end

      it 'sends positional remove_custom_attributes! names as custom attributes only' do
        customer = described_class.new_from_json(uuid: customer_uuid,
                                                 attributes: { tags: [], custom: { age: 18, salesRep: 'Gabi' } })
        stub_api_request(:delete, "/v1/customers/#{customer_uuid}/attributes/custom", '{"custom":{}}')

        customer.remove_custom_attributes!(:age, 'salesRep')

        expect(customer.custom_attributes).to eq({})
        expect(sent_body).to eq('custom' => %w[age salesRep])
      end

      it 'sends brace-less add_custom_attributes_by_email! args as custom attributes only' do
        stub_api_request(:post, '/v1/customers/attributes/custom', '{"entries":[]}')

        result = described_class.add_custom_attributes_by_email!(
          'customer@example.com', type: 'String', key: 'MyChannel', value: 'Facebook'
        )

        expect(result[:entries]).to eq([])
        expect(sent_body).to eq('email' => 'customer@example.com',
                                'custom' => [{ 'type' => 'String', 'key' => 'MyChannel', 'value' => 'Facebook' }])
      end

      it 'sends a brace-less attribute combined with overrides as attribute plus top-level overrides' do
        customer = described_class.new_from_json(uuid: customer_uuid, attributes: { tags: [], custom: {} })
        stub_api_request(:post, "/v1/customers/#{customer_uuid}/attributes/custom",
                         '{"custom":{"MyChannel":"Facebook"},"overrides":{"custom":{"MyChannel":true}}}')

        customer.add_custom_attributes!(type: 'String', key: 'MyChannel', value: 'Facebook',
                                        overrides: { custom: { MyChannel: true } })

        expect(sent_body).to eq('custom' => [{ 'type' => 'String', 'key' => 'MyChannel', 'value' => 'Facebook' }],
                                'overrides' => { 'custom' => { 'MyChannel' => true } })
      end

      it 'sends brace-less update_custom_attributes! attributes combined with overrides correctly' do
        customer = described_class.new_from_json(uuid: customer_uuid, attributes: { tags: [], custom: {} })
        stub_api_request(:put, "/v1/customers/#{customer_uuid}/attributes/custom",
                         '{"custom":{"MyChannel":"Twitter"},"overrides":{"custom":{"MyChannel":true}}}')

        customer.update_custom_attributes!(MyChannel: 'Twitter', overrides: { custom: { MyChannel: true } })

        expect(sent_body).to eq('custom' => { 'MyChannel' => 'Twitter' },
                                'overrides' => { 'custom' => { 'MyChannel' => true } })
      end

      it 'updates a custom attribute literally named overrides through the braced form' do
        customer = described_class.new_from_json(uuid: customer_uuid, attributes: { tags: [], custom: {} })
        stub_api_request(:put, "/v1/customers/#{customer_uuid}/attributes/custom", '{"custom":{"overrides":"x"}}')

        customer.update_custom_attributes!({ overrides: 'x' })

        expect(sent_body).to eq('custom' => { 'overrides' => 'x' })
      end

      it 'sends a brace-less by-email attribute combined with overrides as attribute plus top-level overrides' do
        stub_api_request(:post, '/v1/customers/attributes/custom', '{"entries":[]}')

        described_class.add_custom_attributes_by_email!(
          'customer@example.com', type: 'String', key: 'MyChannel', value: 'Facebook',
                                  overrides: { custom: { MyChannel: true } }
        )

        expect(sent_body).to eq('email' => 'customer@example.com',
                                'custom' => [{ 'type' => 'String', 'key' => 'MyChannel', 'value' => 'Facebook' }],
                                'overrides' => { 'custom' => { 'MyChannel' => true } })
      end
    end

    context 'with overrides echoed back by responses' do
      let(:patch_response) do
        %({"uuid":"#{customer_uuid}","company":"New Co","overrides":{"company":true}})
      end

      it 'does not resend overrides from a retrieved customer on update!' do
        customer = described_class.new_from_json(
          uuid: customer_uuid, company: 'Pinned Co', overrides: { company: true }
        )
        stub_api_request(:patch, "/v1/customers/#{customer_uuid}", patch_response)

        customer.company = 'New Co'
        customer.update!

        expect(sent_body).not_to have_key('overrides')
        expect(sent_body['company']).to eq('New Co')
      end

      it 'freezes overrides echoed by responses so in-place edits fail instead of vanishing' do
        customer = described_class.new_from_json(
          uuid: customer_uuid, overrides: { website_url: true, attributes: { custom: { MyChannel: true } } }
        )

        expect { customer.overrides[:company] = true }.to raise_error(FrozenError)
        expect { customer.overrides[:attributes][:custom][:Other] = true }.to raise_error(FrozenError)

        customer.overrides = { company: true }
        expect { customer.overrides[:owner] = true }.not_to raise_error
      end

      it 'sends explicitly assigned overrides exactly once' do
        customer = described_class.new_from_json(uuid: customer_uuid, company: 'Old Co')
        stub_api_request(:patch, "/v1/customers/#{customer_uuid}", patch_response)

        customer.company = 'New Co'
        customer.overrides = { company: true }
        customer.update!
        expect(sent_body['overrides']).to eq('company' => true)
        expect(customer.overrides).to eq(company: true)

        customer.update!
        expect(sent_body).not_to have_key('overrides')
      end
    end

    describe 'API Actions', uses_api: true, vcr: true do
      it 'creates the customer with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        customer = described_class.create!(
          data_source_uuid: data_source_uuid,
          external_id: 'cus_ov_001',
          company: 'Pinned Co',
          overrides: { company: true }
        )

        expect(customer.overrides).to eq(company: true)
      end

      it 'adds custom attributes with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        customer = described_class.new_from_json(uuid: customer_uuid, attributes: { tags: [], custom: {} })
        updated_attributes = customer.add_custom_attributes!(
          { type: 'String', key: 'MyChannel', value: 'Facebook' },
          overrides: { custom: { MyChannel: true } }
        )

        expect(updated_attributes).to eq(MyChannel: 'Facebook')
      end

      it 'updates custom attributes with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        customer = described_class.new_from_json(uuid: customer_uuid,
                                                 attributes: { tags: [], custom: { MyChannel: 'Facebook' } })
        updated_attributes = customer.update_custom_attributes!({ MyChannel: 'Twitter' },
                                                                overrides: { custom: { MyChannel: true } })

        expect(updated_attributes).to eq(MyChannel: 'Twitter')
      end

      it 'removes custom attributes with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        customer = described_class.new_from_json(uuid: customer_uuid,
                                                 attributes: { tags: [], custom: { MyChannel: 'Twitter', age: 18 } })
        response = customer.remove_custom_attributes!(:age, overrides: { custom: { age: false } })

        expect(response[:message]).to eq('Custom attributes deleted from customer')
        expect(response[:overrides]).to eq(custom: { MyChannel: true })
        expect(customer.custom_attributes).to eq(MyChannel: 'Twitter')
      end

      it 'adds custom attributes by email with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        result = described_class.add_custom_attributes_by_email!(
          'overrides-vcr@example.com',
          { type: 'String', key: 'MyChannel', value: 'Facebook' },
          overrides: { custom: { MyChannel: true } }
        )

        expect(result[:entries].first[:overrides]).to eq(attributes: { custom: { MyChannel: true } })
      end

      it 'retrieves the customer attributes with overrides and history correctly',
         vcr: { match_requests_on: %i[method uri body] } do
        result = described_class.retrieve_attributes(customer_uuid,
                                                     with_overrides: true,
                                                     attributes_with_history: 'custom.MyChannel')

        expect(result[:overrides]).to eq(custom: { MyChannel: true })
        expect(result[:historical_values][:custom][:MyChannel].first).to include(value: 'Facebook', initial: false)
      end
    end
  end
end
