# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CustomerNote do
  let(:attrs) do
    {
      customer_note_uuid: customer_note_uuid,
      customer_uuid: customer_uuid,
    }
  end
  let(:customer_uuid) { 'cus_23e01538-2c7e-11ee-b2ce-fb986e96e21b' }
  let(:customer_note_uuid) { 'note_36399f04-7686-11ee-86f6-8727560009c2' }
  let(:cursor) do
    'MjAyMy0xMC0yOVQxODowODo1MC4yNDQ4NzUwMDBaJmNvbl8z'\
    'NjM5OWYwNC03Njg2LTExZWUtODZmNi04NzI3NTYwMDA5YzI='
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes({ customer_uuid: nil, customer_note_uuid: nil })
    end

    it 'sets the writeable properties correctly' do
      expect(subject).to have_attributes(attrs.reject { |k, _| k == :customer_uuid || k == :customer_note_uuid })
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves the customer note correctly' do
      customer_note = described_class.retrieve(customer_uuid, customer_note_uuid)

      expect(customer_note).to have_attributes(
        uuid: customer_uuid,
        customer_note_uuid: customer_note_uuid,
        type: 'call'
      )
    end

    it 'creates the customer note correctly' do
      attributes = {
        uuid: customer_uuid,
        customer_note_uuid: customer_note_uuid,
        type: 'call'
      }
      customer_note = described_class.create!(**attributes)
      expect(customer_note).to have_attributes(
        **attributes
      )
    end

    it 'updates the customer note correctly with the class method' do
      updated_customer_note = described_class.update!(
        text: 'Updated text',
      )

      expect(updated_customer_note).to have_attributes(
        **updated_attributes
      )
    end

    it 'destroys the customer note correctly' do
      uuid_to_delete = 'con_ab1e60d4-7690-11ee-84d7-f7e55168a5df'
      deleted_customer_note = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_customer_note).to eq(true)
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
        customer_notes = ChartMogul::CustomerNote.all(per_page: 1)
        expect(customer_notes).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(customer_notes.first).to have_attributes(
          uuid: 'con_36399f04-7686-11ee-86f6-8727560009c2'
        )

        next_customer_notes = customer_notes.next(per_page: 1)
        expect(next_customer_notes).to have_attributes(
          cursor: next_cursor,
          has_more: true,
          size: 1
        )
        expect(next_customer_notes.first).to have_attributes(
          uuid: 'con_e07fc356-749e-11ee-bd40-9fcb07f4aeda'
        )
      end
    end
  end
end
