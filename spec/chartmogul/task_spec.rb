# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Task do
  let(:attrs) do
    {
      task_uuid: task_uuid,
      customer_uuid: customer_uuid,
      task_details: 'This is some task details text.',
      assignee: 'keith+test1@chartmogul.com',
      due_date: '2025-04-30T00:00:00.000Z',
      completed_at: nil
    }
  end

  let(:task_uuid) { '6c969fee-2179-11f0-8d8c-ef2a5afba642' }
  let(:customer_uuid) { 'cus_9c8cc2bd-762e-4d93-ae34-1cfb53a53f64' }
  let(:updated_attributes) { { task_details: 'This is updated task details text.' } }
  let(:cursor) { 'MjAyNS0wNC0yNVQwMjowMTowOC4zNTM0NDEwMDBaJjI3NWJjMGJjLTIxNzktMTFmMC04OTdiLWYzZTcwZDJhYTU4ZA==' }

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes({ customer_uuid: nil, task_uuid: nil, created_at: nil, updated_at: nil })
    end

    it 'sets the writeable properties correctly' do
      expect(subject).to have_attributes(attrs.reject do |k, _|
                                           %i[customer_uuid task_uuid created_at updated_at].include?(k)
                                         end)
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs)
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves all tasks correctly' do
      tasks = described_class.all(customer_uuid: customer_uuid)

      expect(tasks.first).to have_attributes(
        task_uuid: task_uuid,
        customer_uuid: customer_uuid
      )
      expect(tasks.cursor).to eq(cursor)
      expect(tasks.has_more).to eq(false)
    end

    it 'retrieves a task correctly' do
      task = described_class.retrieve(task_uuid)

      expect(task).to have_attributes(
        task_uuid: task_uuid,
        customer_uuid: customer_uuid
      )
    end

    it 'creates a task correctly' do
      attributes = attrs.reject { |key, _| key == :task_uuid }
      task = described_class.create!(**attributes)
      expect(task).to have_attributes(**attributes)
    end

    it 'updates the task correctly with the class method' do
      updated_task = described_class.update!(
        task_uuid, **updated_attributes
      )

      expect(updated_task).to have_attributes(
        task_uuid: task_uuid,
        customer_uuid: customer_uuid,
        **updated_attributes
      )
    end

    it 'destroys the task correctly' do
      target_task_uuid = 'd8c374e0-b9ef-47cf-a5a5-4c71fe0a1466'
      deleted_task = described_class.destroy!(uuid: target_task_uuid)
      expect(deleted_task).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyNS0wNC0yNVQwMjoxNTowNi40NzQzNTQwMDBaJjFhZWFlMTA4LTIxN2ItMTFmMC1iMmI0LTViNDJmMDI1MDYyYw=='
      end
      let(:next_cursor) do
        'MjAyNS0wNC0yNVQwMjoxMjo1MS43NTc5NTcwMDBaJmNhOWVjOWM2LTIxN2EtMTFmMC1iMWUyLTZmNjczZGFjYmI4Nw=='
      end

      it 'paginates correctly' do
        tasks = ChartMogul::Task.all(per_page: 1)
        expect(tasks).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(tasks.first).to have_attributes(task_uuid: '1aeae108-217b-11f0-b2b4-5b42f025062c')

        next_tasks = tasks.next(per_page: 1, customer_uuid: customer_uuid)
        expect(next_tasks).to have_attributes(
          cursor: next_cursor,
          has_more: false,
          size: 1
        )
        expect(next_tasks.first).to have_attributes(task_uuid: task_uuid)
      end
    end
  end
end
