# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::PlanGroups::Plans do
  describe 'API Actions', vcr: true, uses_api: true do
    let(:plan_group_uuid) { 'plg_5f1af63a-ec94-4688-9127-5eb816d05a8f' }

    context 'with old pagination' do
      it 'paginates correctly' do
        plans = described_class.all(
          plan_group_uuid,
          per_page: 1, page: 1
        )
        expect(plans.size).to eq(1)
        expect(plans).to have_attributes(
          cursor: nil, has_more: nil,
          current_page: 1, total_pages: 2
        )
        expect(plans.plans.first.uuid).to eq('pl_e205d990-56e3-013c-13ac-46813c1ddd3d')
      end
    end

    context 'with new pagination' do
      let(:first_cursor) do
        'MjAyMy0xMC0yN1QxMDo0NTozNS4yMjM5MDUwMDBaJjEwOTk1ODQ='
      end
      let(:next_cursor) do
        'MjAyMy0xMC0yN1QwNzozMTo1NC40MzQzNDkwMDBaJjEwOTk1MzI='
      end

      it 'paginates correctly' do
        plans = described_class.all(plan_group_uuid, per_page: 1)
        expect(plans).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(plans.plans.map(&:uuid)).to eq(
          ['pl_e205d990-56e3-013c-13ac-46813c1ddd3d']
        )

        next_plans = plans.next(plan_group_uuid, per_page: 1)
        expect(next_plans).to have_attributes(
          cursor: next_cursor,
          has_more: false,
          size: 1
        )
        expect(next_plans.first).to have_attributes(
          uuid: 'pl_e6ffcc84-749a-11ee-be12-f32dce10118e'
        )
      end
    end
  end
end
