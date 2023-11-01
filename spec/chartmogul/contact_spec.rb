# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Contact do
  let(:attrs) do
    {
      uuid: contact_uuid,
      customer_uuid: customer_uuid,
      data_source_uuid: data_source_uuid,
      customer_external_id: 'cus_004',
      first_name: 'First name',
      last_name: 'Last name',
      position: 9,
      title: 'CEO',
      email: 'contact@example.com',
      phone: '+1234567890',
      linked_in: 'https://linkedin.com/not_found',
      twitter: 'https://twitter.com/not_found',
      notes: 'Heading\nBody\nFooter',
      custom: {
        MyStringAttribute: 'Test',
        MyIntegerAttribute: 123,
      }
    }
  end
  let(:contact_uuid) { 'con_36399f04-7686-11ee-86f6-8727560009c2' }
  let(:customer_uuid) { 'cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b' }
  let(:data_source_uuid) { 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46' }
  let(:updated_attributes) do
    {
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
      expect(subject).to have_attributes(attrs.reject { |k, _| k == :uuid })
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs)
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves the contact correctly' do
      contact = described_class.retrieve(contact_uuid)

      expect(contact).to have_attributes(
        uuid: contact_uuid,
        customer_uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        email: 'contact@example.com'
      )
    end

    it 'creates the contact correctly' do
      attributes = {
        customer_uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        email: 'contact@example.com'
      }
      contact = described_class.create!(**attributes)
      expect(contact).to have_attributes(uuid: contact_uuid, **attributes)
    end

    it 'updates the contact correctly with the class method' do
      updated_contact = described_class.update!(
        contact_uuid, **updated_attributes
      )

      expect(updated_contact).to have_attributes(
        uuid: contact_uuid,
        data_source_uuid: data_source_uuid,
        customer_uuid: customer_uuid,
        **updated_attributes
      )
    end

    it 'destroys the contact correctly' do
      uuid_to_delete = 'con_ab1e60d4-7690-11ee-84d7-f7e55168a5df'
      deleted_contact = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_contact).to eq(true)
    end

    it 'merges contacts correctly' do
      into_uuid = contact_uuid
      from_uuid = 'con_6f0b7208-7690-11ee-8857-9f75f1321afd'

      contact_result = described_class.merge!(
        into_uuid: into_uuid, from_uuid: from_uuid
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
end
