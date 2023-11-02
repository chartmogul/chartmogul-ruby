# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Plan do
  let(:plan_uuid)        { 'pl_de9e281e-76cb-11ee-b63f-b727630ce4d4' }
  let(:data_source_uuid) { 'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46' }

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves the plan correctly' do
      plan = described_class.retrieve(plan_uuid)
      expect(plan).to have_attributes(
        uuid: plan_uuid,
        name: 'Test Plan',
        external_id: 'test_cus_pl_ext_id',
        data_source_uuid: data_source_uuid
      )
    end

    it 'creates the plan correctly' do
      plan = described_class.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'Another Test Plan',
        data_source_uuid: data_source_uuid
      )
      expect(plan).to have_attributes(
        uuid: 'pl_1184b750-5905-013c-13b1-46813c1ddd3d',
        name: 'Another Test Plan',
        data_source_uuid: data_source_uuid
      )
    end

    it 'updates the plan correctly with the instance method' do
      plan = described_class.retrieve('pl_1184b750-5905-013c-13b1-46813c1ddd3d')
      plan.name = 'Another Test Plan 123'
      plan.interval_count = 2
      updated_plan = plan.update!

      expect(updated_plan).to have_attributes(
        uuid: 'pl_1184b750-5905-013c-13b1-46813c1ddd3d',
        name: 'Another Test Plan 123',
        interval_count: 2
      )
    end

    it 'updates the plan correctly with the class method' do
      updated_plan = described_class.update!(
        'pl_1184b750-5905-013c-13b1-46813c1ddd3d',
        name: 'Another Test Plan', interval_count: 1
      )
      expect(updated_plan).to have_attributes(
        uuid: 'pl_1184b750-5905-013c-13b1-46813c1ddd3d',
        name: 'Another Test Plan',
        interval_count: 1
      )
    end

    it 'destroys the plan correctly' do
      uuid_to_delete = 'pl_1184b750-5905-013c-13b1-46813c1ddd3d'
      deleted_plan = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_plan).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyMy0xMC0zMFQwMjoyNzoyOC4wMzU1OTIwMDBaJjExMDAyMjQ='
      end
      let(:next_cursor) do
        'MjAyMy0xMC0yN1QxMDo0NTozNS4yMjM5MDUwMDBaJjEwOTk1ODQ='
      end

      it 'paginates correctly' do
        plans = described_class.all(per_page: 1)
        expect(plans).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(plans.first).to have_attributes(
          uuid: 'pl_de9e281e-76cb-11ee-b63f-b727630ce4d4'
        )

        next_plans = plans.next(per_page: 1)
        expect(next_plans).to have_attributes(
          cursor: next_cursor,
          has_more: true,
          size: 1
        )
        expect(next_plans.first).to have_attributes(
          uuid: 'pl_e205d990-56e3-013c-13ac-46813c1ddd3d'
        )
      end
    end
  end
end
