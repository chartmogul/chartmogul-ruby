# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::EntityNote do
  let(:attrs) do
    {
      uuid: note_uuid,
      customer_uuid: customer_uuid,
      associated_object: 'customer',
      associated_object_uuid: customer_uuid,
      type: 'note',
      text: 'This is a note',
      author: 'Test User (user@example.com)',
      call_duration: 0,
      created_at: '2026-09-15T10:00:00.000Z',
      updated_at: '2026-09-15T10:00:00.000Z'
    }
  end
  let(:readonly_keys) { %i[uuid associated_object associated_object_uuid author] }
  let(:note_uuid) { 'note_0d5a1b2c-9a6e-11f1-8f1d-0f455cd2fcde' }
  let(:customer_uuid) { 'cus_2f7c3d4e-9a6e-11f1-8f1d-0f455cd2fcde' }
  let(:contact_uuid) { 'con_3a8d4e5f-9a6e-11f1-8f1d-0f455cd2fcde' }
  let(:contact_identifier) { { associated_object: 'contact', method: 'uuid', value: contact_uuid } }

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes(uuid: nil, associated_object: nil, associated_object_uuid: nil, author: nil)
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

    context 'with a contact note' do
      subject do
        described_class.new_from_json(
          attrs.merge(customer_uuid: nil, associated_object: 'contact', associated_object_uuid: contact_uuid)
        )
      end

      it 'leaves customer_uuid nil and exposes the associated contact' do
        expect(subject).to have_attributes(
          customer_uuid: nil,
          associated_object: 'contact',
          associated_object_uuid: contact_uuid
        )
      end
    end
  end

  describe '#serialize_for_write' do
    subject do
      described_class.new(
        type: 'call',
        text: 'Called the contact',
        author_email: 'user@example.com',
        call_duration: 60,
        associated_object_identifier: contact_identifier
      )
    end

    it 'serializes the nested identifier and skips read-only attributes' do
      expect(subject.serialize_for_write).to eq(
        type: 'call',
        text: 'Called the contact',
        author_email: 'user@example.com',
        call_duration: 60,
        associated_object_identifier: contact_identifier
      )
    end

    it 'omits a nil customer_uuid' do
      contact_note = described_class.new_from_json(attrs.merge(customer_uuid: nil))
      expect(contact_note.serialize_for_write).not_to have_key(:customer_uuid)
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    let(:user_email) { 'user@example.com' }

    it 'correctly interacts with the API' do
      data_source = ChartMogul::DataSource.create!(name: 'Entity Note Test Data Source')
      customer = ChartMogul::Customer.create!(
        data_source_uuid: data_source.uuid, name: 'Entity Note Customer', external_id: 'entity_note_cus_001'
      )
      contact = ChartMogul::Contact.create!(first_name: 'Entity', last_name: 'Note', email: 'entity-note@example.com')

      customer_note = described_class.create!(customer_uuid: customer.uuid, type: 'note', text: 'This is a note')
      expect(customer_note.uuid).to start_with('note_')
      expect(customer_note).to have_attributes(
        customer_uuid: customer.uuid,
        associated_object: 'customer',
        associated_object_uuid: customer.uuid,
        type: 'note',
        text: 'This is a note'
      )

      contact_note = described_class.create!(
        associated_object_identifier: { associated_object: 'contact', method: 'uuid', value: contact.uuid },
        type: 'call',
        text: 'Called the contact',
        call_duration: 90,
        author_email: user_email
      )
      expect(contact_note).to have_attributes(
        customer_uuid: nil,
        associated_object: 'contact',
        associated_object_uuid: contact.uuid,
        type: 'call',
        call_duration: 90
      )
      expect(contact_note.author).to include(user_email)

      expect(described_class.all(customer_uuid: customer.uuid).map(&:uuid)).to eq([customer_note.uuid])
      expect(described_class.all(contact_uuid: contact.uuid).map(&:uuid)).to eq([contact_note.uuid])
      expect(described_class.all(type: 'call', author_email: user_email).map(&:uuid)).to include(contact_note.uuid)

      retrieved_note = described_class.retrieve(customer_note.uuid)
      expect(retrieved_note).to have_attributes(uuid: customer_note.uuid, text: 'This is a note')

      updated_note = described_class.update!(customer_note.uuid, text: 'This is an updated note')
      expect(updated_note).to have_attributes(uuid: customer_note.uuid, text: 'This is an updated note')
      expect(described_class.update!(customer_note.uuid)).to be_a(described_class)

      second_note = described_class.create!(customer_uuid: customer.uuid, type: 'note', text: 'Second note')
      page = described_class.all(customer_uuid: customer.uuid, per_page: 1)
      expect(page).to have_attributes(size: 1, has_more: true)
      next_page = page.next(customer_uuid: customer.uuid, per_page: 1)
      expect(next_page).to have_attributes(size: 1, has_more: false)
      expect([page.first.uuid, next_page.first.uuid]).to match_array([customer_note.uuid, second_note.uuid])

      [customer_note, second_note, contact_note].each do |note|
        expect(described_class.destroy!(uuid: note.uuid)).to eq(true)
      end
      ChartMogul::Contact.destroy!(uuid: contact.uuid)
      data_source.destroy!
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end
  end

  describe 'PATCH with nothing to update', uses_api: true do
    let(:url) { "#{ChartMogul.api_base}/v1/notes/#{note_uuid}" }

    before { stub_request(:patch, url).to_return(status: 304, body: '') }

    it 'returns an entity note from the class method without raising' do
      VCR.turned_off do
        expect(described_class.update!(note_uuid)).to be_a(described_class)
      end
    end

    it 'keeps the instance attributes intact' do
      VCR.turned_off do
        note = described_class.new_from_json(attrs)
        expect(note.update!).to have_attributes(attrs)
      end
    end
  end
end
