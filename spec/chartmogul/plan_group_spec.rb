# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::PlanGroup, uses_api: true, vcr: true do
  describe 'API Actions' do
    let(:plan_group_uuid) { 'plg_e6ae207a-ff32-4431-ae46-34f20b61e17a' }

    it 'retrieves the plan_group correctly' do
      plan_group = described_class.retrieve(plan_group_uuid)
      expect(plan_group).to have_attributes(
        uuid: plan_group_uuid,
        name: 'My plan group',
        plans_count: 2
      )
    end

    it 'creates a plan_group correctly' do
      plan = ChartMogul::Plan.retrieve('pl_e205d990-56e3-013c-13ac-46813c1ddd3d')
      plan_group = described_class.create!(
        name: 'New Plan Group',
        plans: [plan]
      )
      expect(plan_group).to have_attributes(
        uuid: 'plg_5f1af63a-ec94-4688-9127-5eb816d05a8f',
        name: 'New Plan Group',
        plans_count: 1
      )
    end

    it 'updates the plan_group correctly with the instance method' do
      plan_group = described_class.retrieve(plan_group_uuid)
      plan_group.name = 'A new name'
      updated_plan_group = plan_group.update!
      expect(updated_plan_group).to have_attributes(
        uuid: plan_group_uuid,
        name: 'A new name'
      )
    end

    it 'updates the plan_group correctly with the class method' do
      updated_plan_group = described_class.update!(
        plan_group_uuid, name: 'Another name'
      )
      expect(updated_plan_group).to have_attributes(
        uuid: plan_group_uuid, name: 'Another name'
      )
    end

    it 'updates a plan_group plans' do
      plan_1 = ChartMogul::Plan.retrieve('pl_de9e281e-76cb-11ee-b63f-b727630ce4d4')
      plan_2 = ChartMogul::Plan.retrieve('pl_e205d990-56e3-013c-13ac-46813c1ddd3d')
      plan_group = described_class.retrieve(plan_group_uuid)
      plan_group.plans = [plan_1, plan_2]

      updated_plan_group = plan_group.update!
      expect(updated_plan_group).to have_attributes(
        name: 'Another name',
        plans_count: 2,
        uuid: plan_group_uuid
      )
      expect(updated_plan_group.plans.map(&:uuid)).to match_array([plan_1.uuid, plan_2.uuid])
    end

    it 'destroys a plan_group correctly' do
      plan_group = described_class.retrieve(plan_group_uuid)
      destroyed_plan_group = plan_group.destroy!
      expect(destroyed_plan_group).to eq(true)
    end

    context 'with old pagination' do
      it 'paginates correctly' do
        plan_groups = described_class.all(per_page: 1, page: 3)
        expect(plan_groups.size).to eq(1)
        expect(plan_groups).to have_attributes(
          cursor: nil, current_page: 3, total_pages: 8
        )
        expect(plan_groups.first).to have_attributes(
          uuid: 'plg_cb92ce3a-2196-4b1b-92e1-7bb7c01c359e'
        )
      end
    end

    context 'with new pagination' do
      let(:first_cursor) do
        'MjAyMy0xMC0zMFQwNDowMTo0NS4yNDYwNzQwMDBaJjIxMTg5'
      end
      let(:next_cursor) do
        'MjAyMy0xMC0yN1QxMDo0MzoxMC41MTc3OTcwMDBaJjIxMTgy'
      end

      it 'paginates correctly' do
        plan_groups = described_class.all(per_page: 1)
        expect(plan_groups).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(plan_groups.first).to have_attributes(
          uuid: 'plg_5f1af63a-ec94-4688-9127-5eb816d05a8f'
        )

        next_plan_groups = plan_groups.next(per_page: 1)
        expect(next_plan_groups).to have_attributes(
          cursor: next_cursor,
          has_more: true,
          size: 1
        )
        expect(next_plan_groups.first).to have_attributes(
          uuid: 'plg_596af607-ea77-45a3-8d0b-5f1f6b31bf3b'
        )
      end
    end
  end
end
