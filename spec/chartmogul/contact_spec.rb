# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Contact do
  shared_examples 'creates contact with nil external_id' do
    it 'creates the contact correctly' do
      contact = described_class.create!(**create_attributes)
      expect(contact).to have_attributes(uuid: contact_uuid, external_id: nil)
    end
  end

  let(:attrs) do
    {
      uuid: contact_uuid,
      customer_uuid:,
      data_source_uuid:,
      customer_external_id: 'cus_004',
      external_id: 'contact_external_id_001',
      first_name: 'First name',
      last_name: 'Last name',
      position: 9,
      title: 'CEO',
      email: 'contact@example.com',
      phone: '+1234567890',
      linked_in: 'https://linkedin.com/not_found',
      twitter: 'https://twitter.com/not_found',
      notes: 'Heading\nBody\nFooter',
      last_seen: '2026-09-01T00:00:00.000Z',
      custom: {
        MyStringAttribute: 'Test',
        MyIntegerAttribute: 123
      }
    }
  end
  let(:readonly_keys) { %i[uuid] }
  let(:contact_uuid) { 'con_36399f04-7686-11ee-86f6-8727560009c2' }
  let(:standalone_contact_uuid) { 'con_3a8d4e5f-9a6e-11f1-8f1d-0f455cd2fcde' }
  let(:contact_identifier) { { associated_object: 'contact', method: 'uuid', value: standalone_contact_uuid } }
  let(:customer_uuid) { 'cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b' }
  let(:data_source_uuid) { 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46' }
  let(:updated_attributes) do
    {
      external_id: 'contact_external_id_002',
      first_name: 'Foo',
      last_name: 'Bar',
      email: 'contact2@example.com',
      title: 'CTO',
      position: 9,
      phone: '+9876543210',
      linked_in: 'https://linkedin.com/about',
      twitter: 'https://twitter.com/about',
      custom: { Toggle: false }
    }
  end
  let(:cursor) do
    'MjAyMy0xMC0yOVQxODowODo1MC4yNDQ4NzUwMDBaJmNvbl8z'\
    'NjM5OWYwNC03Njg2LTExZWUtODZmNi04NzI3NTYwMDA5YzI='
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes({ uuid: nil })
    end

    it 'sets the writeable properties correctly' do
      expect(subject).to have_attributes(attrs.reject { |k, _| readonly_keys.include?(k) })
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs)
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    let(:user_email) { 'user@example.com' }

    it 'retrieves the contact correctly' do
      contact = described_class.retrieve(contact_uuid)

      expect(contact).to have_attributes(
        uuid: contact_uuid,
        customer_uuid:,
        data_source_uuid:,
        email: 'contact@example.com'
      )
    end

    it 'creates the contact correctly' do
      attributes = {
        customer_uuid:,
        data_source_uuid:,
        email: 'contact@example.com',
        external_id: 'contact_external_id_001'
      }
      contact = described_class.create!(**attributes)
      expect(contact).to have_attributes(uuid: contact_uuid, **attributes)
    end

    context 'with null external_id' do
      let(:create_attributes) do
        { customer_uuid:, data_source_uuid:, email: 'contact@example.com', external_id: nil }
      end
      include_examples 'creates contact with nil external_id'
    end

    context 'without external_id' do
      let(:create_attributes) do
        { customer_uuid:, data_source_uuid:, email: 'contact@example.com' }
      end
      include_examples 'creates contact with nil external_id'
    end

    it 'updates the contact correctly with the class method' do
      updated_contact = described_class.update!(
        contact_uuid, **updated_attributes
      )

      expect(updated_contact).to have_attributes(
        uuid: contact_uuid,
        data_source_uuid:,
        customer_uuid:,
        **updated_attributes
      )
    end

    it 'updates the contact with null external_id correctly' do
      updated_contact = described_class.update!(contact_uuid, external_id: nil)
      expect(updated_contact).to have_attributes(uuid: contact_uuid, external_id: nil)
    end

    it 'destroys the contact correctly' do
      uuid_to_delete = 'con_ab1e60d4-7690-11ee-84d7-f7e55168a5df'
      deleted_contact = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_contact).to eq(true)
    end

    it 'correctly interacts with the API for standalone contacts' do
      data_source = ChartMogul::DataSource.create!(name: 'Contact Test Data Source')
      customer = ChartMogul::Customer.create!(
        data_source_uuid: data_source.uuid, name: 'Contact Customer', external_id: 'contact_flow_cus_001'
      )
      linked_contact = described_class.create!(
        customer_uuid: customer.uuid,
        data_source_uuid: data_source.uuid,
        email: 'linked@example.com',
        external_id: 'contact_flow_con_001'
      )
      standalone_contact = described_class.create!(
        first_name: 'Stand', last_name: 'Alone', email: 'standalone@example.com'
      )

      expect(standalone_contact.uuid).to start_with('con_')
      expect(standalone_contact).to have_attributes(
        customer_uuid: nil, data_source_uuid: nil, email: 'standalone@example.com'
      )

      expect(described_class.all(email: 'standalone@example.com').map(&:uuid)).to eq([standalone_contact.uuid])
      expect(described_class.all(customer_external_id: 'contact_flow_cus_001').map(&:uuid)).to eq([linked_contact.uuid])
      expect(described_class.all(external_id: 'contact_flow_con_001').map(&:uuid)).to eq([linked_contact.uuid])

      updated_contact = described_class.update!(standalone_contact.uuid, last_seen: '2026-09-01T00:00:00Z')
      expect(updated_contact.last_seen).to start_with('2026-09-01')

      task = standalone_contact.create_task(
        task_details: 'Call the contact', assignee: user_email, due_date: '2026-09-30T00:00:00Z'
      )
      expect(task).to have_attributes(
        customer_uuid: nil, associated_object: 'contact', associated_object_uuid: standalone_contact.uuid
      )
      expect(standalone_contact.tasks.map(&:task_uuid)).to eq([task.task_uuid])

      note = standalone_contact.create_entity_note(type: 'note', text: 'Contact note')
      expect(note).to have_attributes(
        customer_uuid: nil, associated_object: 'contact', associated_object_uuid: standalone_contact.uuid
      )
      expect(standalone_contact.entity_notes.map(&:uuid)).to eq([note.uuid])

      ChartMogul::Task.destroy!(uuid: task.task_uuid)
      ChartMogul::EntityNote.destroy!(uuid: note.uuid)
      described_class.destroy!(uuid: standalone_contact.uuid)
      data_source.destroy!
    end

    it 'merges contacts correctly' do
      into_uuid = contact_uuid
      from_uuid = 'con_6f0b7208-7690-11ee-8857-9f75f1321afd'

      contact_result = described_class.merge!(
        into_uuid:, from_uuid:
      )
      expect(contact_result).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyMy0xMC0yOVQxODowODo1MC4yNDQ4NzUwMDBaJmNvbl8z'\
        'NjM5OWYwNC03Njg2LTExZWUtODZmNi04NzI3NTYwMDA5YzI='
      end
      let(:next_cursor) do
        'MjAyMy0xMC0yN1QwODowMDoyMS41MTQwMzcwMDBaJmNvbl9l'\
        'MDdmYzM1Ni03NDllLTExZWUtYmQ0MC05ZmNiMDdmNGFlZGE='
      end

      it 'paginates correctly' do
        contacts = ChartMogul::Contact.all(per_page: 1)
        expect(contacts).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(contacts.first).to have_attributes(
          uuid: 'con_36399f04-7686-11ee-86f6-8727560009c2'
        )

        next_contacts = contacts.next(per_page: 1)
        expect(next_contacts).to have_attributes(
          cursor: next_cursor,
          has_more: true,
          size: 1
        )
        expect(next_contacts.first).to have_attributes(
          uuid: 'con_e07fc356-749e-11ee-bd40-9fcb07f4aeda'
        )
      end
    end
  end

  describe 'contact-scoped helpers', uses_api: true do
    let(:contact) { described_class.new_from_json(uuid: standalone_contact_uuid) }
    let(:customer_identifier) { { associated_object: 'customer', method: 'uuid', value: customer_uuid } }
    let(:tasks_url) { "#{ChartMogul.api_base}/v1/tasks" }
    let(:notes_url) { "#{ChartMogul.api_base}/v1/notes" }

    around { |example| VCR.turned_off { example.run } }

    describe '#tasks' do
      it 'lists tasks filtered by the contact' do
        stub_request(:get, "#{tasks_url}?per_page=1&contact_uuid=#{standalone_contact_uuid}")
          .to_return(status: 200, body: '{"entries":[]}')

        contact.tasks(per_page: 1)

        expect(WebMock).to have_requested(:get, "#{tasks_url}?per_page=1&contact_uuid=#{standalone_contact_uuid}")
      end
    end

    describe '#create_task' do
      before { stub_request(:post, tasks_url).to_return(status: 201, body: '{}') }

      it 'injects the contact as the associated object' do
        contact.create_task(task_details: 'Call the contact')

        expect(WebMock).to have_requested(:post, tasks_url)
          .with(body: { task_details: 'Call the contact', associated_object_identifier: contact_identifier })
      end

      it 'does not inject when a customer_uuid is given' do
        contact.create_task(task_details: 'Call the contact', customer_uuid: customer_uuid)

        expect(WebMock).to have_requested(:post, tasks_url)
          .with(body: { task_details: 'Call the contact', customer_uuid: customer_uuid })
      end

      it 'does not inject when an identifier is given' do
        contact.create_task(task_details: 'Call the contact', associated_object_identifier: customer_identifier)

        expect(WebMock).to have_requested(:post, tasks_url)
          .with(body: { task_details: 'Call the contact', associated_object_identifier: customer_identifier })
      end
    end

    describe '#entity_notes' do
      it 'lists entity notes filtered by the contact' do
        stub_request(:get, "#{notes_url}?type=call&contact_uuid=#{standalone_contact_uuid}")
          .to_return(status: 200, body: '{"entries":[]}')

        contact.entity_notes(type: 'call')

        expect(WebMock).to have_requested(:get, "#{notes_url}?type=call&contact_uuid=#{standalone_contact_uuid}")
      end
    end

    describe '#create_entity_note' do
      before { stub_request(:post, notes_url).to_return(status: 201, body: '{}') }

      it 'injects the contact as the associated object' do
        contact.create_entity_note(type: 'note', text: 'Hello')

        expect(WebMock).to have_requested(:post, notes_url)
          .with(body: { type: 'note', text: 'Hello', associated_object_identifier: contact_identifier })
      end

      it 'does not inject when a customer_uuid is given' do
        contact.create_entity_note(type: 'note', customer_uuid: customer_uuid)

        expect(WebMock).to have_requested(:post, notes_url)
          .with(body: { type: 'note', customer_uuid: customer_uuid })
      end

      it 'does not inject when an identifier is given' do
        contact.create_entity_note(type: 'note', associated_object_identifier: customer_identifier)

        expect(WebMock).to have_requested(:post, notes_url)
          .with(body: { type: 'note', associated_object_identifier: customer_identifier })
      end
    end
  end

  describe 'Overrides' do
    it 'serializes overrides for write alongside custom attributes' do
      contact = described_class.new(
        customer_uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        title: 'CTO',
        custom: { Facebook: 'https://www.facebook.com/example' },
        overrides: { title: true }
      )
      serialized = contact.serialize_for_write

      expect(serialized[:overrides]).to eq(title: true)
      expect(serialized[:custom]).to eq([{ key: :Facebook, value: 'https://www.facebook.com/example' }])
    end

    it_behaves_like 'retrieve with query params', 'con_36399f04-7686-11ee-86f6-8727560009c2',
                    { with_overrides: true, attributes_with_history: 'title' },
                    <<-JSON,
                    {
                      "uuid": "con_36399f04-7686-11ee-86f6-8727560009c2",
                      "title": "CTO",
                      "custom": { "MyChannel": "Facebook" },
                      "overrides": { "title": true },
                      "historical_values": {
                        "title": [
                          { "value": "CTO", "update_performed_at": "2026-09-01T10:00:00Z", "update_performed_by": "user@example.com", "initial": false }
                        ]
                      }
                    }
                    JSON
                    lambda { |contact|
                      expect(contact.overrides).to eq(title: true)
                      expect(contact.custom).to eq(MyChannel: 'Facebook')
                      expect(contact.historical_values[:title].first).to eq(
                        value: 'CTO',
                        update_performed_at: '2026-09-01T10:00:00Z',
                        update_performed_by: 'user@example.com',
                        initial: false
                      )
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

    context 'with overrides echoed back by responses' do
      let(:patch_response) do
        '{"uuid":"con_36399f04-7686-11ee-86f6-8727560009c2","title":"CEO","custom":{},"overrides":{"title":true}}'
      end

      it 'does not resend overrides from a retrieved contact on update!' do
        contact = described_class.new_from_json(uuid: contact_uuid, title: 'CTO', overrides: { title: true })
        stub_api_request(:patch, "/v1/contacts/#{contact_uuid}", patch_response)

        contact.title = 'CEO'
        contact.update!

        expect(sent_body).not_to have_key('overrides')
        expect(sent_body['title']).to eq('CEO')
      end

      it 'sends explicitly assigned overrides exactly once' do
        contact = described_class.new_from_json(uuid: contact_uuid, title: 'CTO')
        stub_api_request(:patch, "/v1/contacts/#{contact_uuid}", patch_response)

        contact.title = 'CEO'
        contact.overrides = { title: true }
        contact.update!
        expect(sent_body['overrides']).to eq('title' => true)
        expect(contact.overrides).to eq(title: true)

        contact.update!
        expect(sent_body).not_to have_key('overrides')
      end
    end

    describe 'API Actions', uses_api: true, vcr: true do
      it 'creates the contact with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        contact = described_class.create!(
          customer_uuid: customer_uuid,
          data_source_uuid: data_source_uuid,
          title: 'CTO',
          overrides: { title: true }
        )

        expect(contact.overrides).to eq(title: true)
      end

      it 'updates the contact with overrides correctly', vcr: { match_requests_on: %i[method uri body] } do
        updated_contact = described_class.update!(contact_uuid, title: 'CEO', overrides: { title: true })

        expect(updated_contact.title).to eq('CEO')
        expect(updated_contact.overrides).to eq(title: true)
      end
    end
  end
end
