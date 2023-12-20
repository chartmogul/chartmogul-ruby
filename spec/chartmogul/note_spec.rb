# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Note do
  let(:attrs) do
    {
      uuid: note_uuid,
      customer_uuid: customer_uuid,
      type: 'note',
      text: 'This is a note',
    }
  end
  let(:note_uuid) { 'note_6bbb8a6e-9b45-11ee-8f1d-8f455cd2fcde' }
  let(:customer_uuid) { 'cus_58f81bdc-94e6-11ee-ba3e-63f79c1ac982' }
  let(:updated_attributes) do
    {
      text: "This is a updated note"
    }
  end
  let(:cursor) do
    'MjAyMy0xMi0xNVQxMjoyNTo1Ni45NTA4MTcwMDBaJm5v'\
    'dGVfMThmZmMzYmMtOWI0NS0xMWVlLTgxNDMtMDdjYTg2ZTVlZTEw'
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
    it 'retrieves all notes correctly' do
      notes = described_class.all(customer_uuid: customer_uuid)

      expect(notes.first).to have_attributes(
        uuid: note_uuid,
        customer_uuid: customer_uuid
      )
      expect(notes.cursor).to eq(cursor)
      expect(notes.has_more).to eq(false)
    end

    it 'retrieves a note correctly' do
      note = described_class.retrieve(note_uuid)

      expect(note).to have_attributes(
        uuid: note_uuid,
        customer_uuid: customer_uuid
      )
    end

    it 'creates a note correctly' do
      attributes = {
        customer_uuid: customer_uuid,
        text: 'This is a note',
        type: 'note'
      }
      note = described_class.create!(**attributes)
      expect(note).to have_attributes(**attributes)
    end

    it 'updates the note correctly with the class method' do
      updated_note = described_class.update!(
        note_uuid, **updated_attributes
      )

      expect(updated_note).to have_attributes(
        uuid: note_uuid,
        customer_uuid: customer_uuid,
        **updated_attributes
      )
    end

    it 'destroys the note correctly' do
      target_note_uuid = 'note_18ffc3bc-9b45-11ee-8143-07ca86e5ee10'
      deleted_note= described_class.destroy!(uuid: target_note_uuid)
      expect(deleted_note).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyMy0xMi0xNVQxMjo0NToxMi41NDgwNzAwMDBaJ'\
        'm5vdGVfYzljOWU3YjYtOWI0Ny0xMWVlLWEzZDgtMGY2OTVjNTM1NDRj'
      end
      let(:next_cursor) do
        'MjAyMy0xMi0xNVQxMjoyODoxNS43NTQ0ODUwMDBaJ'\
        'm5vdGVfNmJiYjhhNmUtOWI0NS0xMWVlLThmMWQtOGY0NTVjZDJmY2Rl'
      end

      it 'paginates correctly' do
        notes = ChartMogul::Note.all(per_page: 1, customer_uuid: customer_uuid)
        expect(notes).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(notes.first).to have_attributes(
          uuid: 'note_c9c9e7b6-9b47-11ee-a3d8-0f695c53544c'
        )

        next_notes = notes.next(per_page: 1, customer_uuid: customer_uuid)
        expect(next_notes).to have_attributes(
          cursor: next_cursor,
          has_more: false,
          size: 1
        )
        expect(next_notes.first).to have_attributes(
          uuid: 'note_6bbb8a6e-9b45-11ee-8f1d-8f455cd2fcde'
        )
      end
    end
  end
end
