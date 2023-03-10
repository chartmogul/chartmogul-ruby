# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Contact do
  let(:attrs) do
    {
      uuid: 'con_00000000-0000-0000-0000-000000000000',
      customer_uuid: 'cus_00000000-0000-0000-0000-000000000000',
      data_source_uuid: 'ds_00000000-0000-0000-0000-000000000000',
      customer_external_id: 'external_001',
      first_name: 'First name',
      last_name: 'Last name',
      position: 9,
      title: 'Title',
      email: 'test@example.com',
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

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes({
        uuid: nil,
        customer_uuid: nil,
        data_source_uuid: nil
      })
    end

    it 'sets the writable properties correctly' do
      expect(subject).to have_attributes({
        customer_external_id: 'external_001',
        first_name: 'First name',
        last_name: 'Last name',
        position: 9,
        title: 'Title',
        email: 'test@example.com',
        phone: '+1234567890',
        linked_in: 'https://linkedin.com/not_found',
        twitter: 'https://twitter.com/not_found',
        notes: 'Heading\nBody\nFooter',
        custom: {
          MyStringAttribute: 'Test',
          MyIntegerAttribute: 123,
        }
      })
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs)
    end
  end

  describe 'API Interactions', vcr: true do
    it 'creates contact correctly', uses_api: true do
      ds = ChartMogul::DataSource.create!(name: 'Customer Test Data Source')
      customer = ChartMogul::Customer.create!(
        name: 'Test Customer',
        external_id: 'X1234',
        data_source_uuid: ds.uuid,
        email: 'test@example.com',
      )
      contact = described_class.create!(
        customer_uuid: customer.uuid,
        data_source_uuid: ds.uuid,
        email: 'test@example.com'
      )

      retrieved_contact = described_class.retrieve(contact.uuid)
      expect(retrieved_contact.uuid).to be_a_kind_of(String)
      expect(retrieved_contact.customer_uuid).to eq(customer.uuid)
      expect(retrieved_contact.data_source_uuid).to eq(ds.uuid)
      expect(retrieved_contact.email).to eq('test@example.com')
    end

    it 'updates contact correctly', uses_api: true do
      contact_id = 'con_8305e66c-bf2f-11ed-a4cb-db537410c51b'
      contact = described_class.retrieve(contact_id)

      contact.first_name = 'Foo'
      contact.last_name = 'Bar'
      contact.email = 'test2@example.com'
      contact.title = 'CTO'
      contact.position = 9
      contact.phone = '+9876543210'
      contact.linked_in = 'https://linkedin.com/about'
      contact.twitter = 'https://twitter.com/about'
      contact.custom = { Toggle: false }

      contact.update!

      updated_contact = described_class.retrieve(contact_id)
      expect(updated_contact.first_name).to eq 'Foo'
      expect(updated_contact.last_name).to eq 'Bar'
      expect(updated_contact.email).to eq 'test2@example.com'
      expect(updated_contact.title).to eq 'CTO'
      expect(updated_contact.position).to eq 9
      expect(updated_contact.phone).to eq '+9876543210'
      expect(updated_contact.linked_in).to eq 'https://linkedin.com/about'
      expect(updated_contact.twitter).to eq 'https://twitter.com/about'
      expect(updated_contact.custom).to eq ({ Toggle: false })
    end

    it 'destroys contact correctly', uses_api: true do
      contact_id = 'con_e2894d28-9189-11ed-8100-ffadd676801d'
      contact = described_class.retrieve(contact_id)
      contact.destroy!

      expect do
        described_class.retrieve(contact_id)
      end.to raise_error(ChartMogul::NotFoundError)
    end

    it 'merges contact correctly', uses_api: true do
      into_uuid = 'con_f4ef7c64-bf27-11ed-92ad-a7d034bf3085'
      from_uuid = 'con_33dd5606-bf2a-11ed-a7d0-17036209bd22'
      contact_into = described_class.retrieve(into_uuid)
      contact_from = described_class.retrieve(from_uuid)

      expect(contact_into.notes).to eq('Hello')
      expect(contact_from.notes).to eq('World')

      contact_result = described_class.merge!(into_uuid: into_uuid, from_uuid: from_uuid)
      expect(contact_result.notes).to eq('Hello World')
    end

    it 'paginates correctly', uses_api: true do
      all_contacts = ChartMogul::Contacts.all
      expect(all_contacts.has_more).to be(false)
      expect(all_contacts.map(&:first_name)).to match_array(%w[contact1 contact2 contact3 contact4 contact5])

      contacts = ChartMogul::Contacts.all(per_page: 3)
      expect(contacts.has_more).to be(true)
      expect(contacts.map(&:first_name)).to match_array(%w[contact1 contact2 contact3])

      contacts = contacts.next(per_page: 3)
      expect(contacts.has_more).to be(false)
      expect(contacts.map(&:first_name)).to match_array(%w[contact4 contact5])
    end
  end
end
