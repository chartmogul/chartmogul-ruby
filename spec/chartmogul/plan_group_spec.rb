# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::PlanGroup, uses_api: true do
  describe 'API interactions', vcr: true, record: :all do
    let(:data_source) do
      ChartMogul::DataSource.create!(name: 'Data Source #1')
    end

    let(:plan1) do
      ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A Test Plan',
        data_source_uuid: data_source.uuid
      )
    end

    let(:plan2) do
      ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A another Test Plan',
        data_source_uuid: data_source.uuid
      )
    end

    let(:plan_group) do
      ChartMogul::PlanGroup.create!(
        name: 'My plan group',
        plans: [plan1, plan2]
      )
    end

    it 'creates a plan group correctly', uses_api: true do
      plan_group

      expect(plan_group.uuid).to eq("plg_c2c3f51f-822f-4b13-a3ff-58eb14ba327d")
      expect(plan_group.plans_count).to eq(2)
    end

    it 'correctly handles a 422 error', uses_api: true do
      expect { ChartMogul::PlanGroup.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'retrieves existing plan group by uuid', uses_api: true do
      api_pg = ChartMogul::PlanGroup.retrieve(plan_group.uuid)

      expect(api_pg.uuid).to eq(plan_group.uuid)
    end

    it 'paginates correctly', uses_api: true do
      plan_groups = described_class.all(per_page: 1)
      expect(plan_groups.has_more).to be(true)
      expect(plan_groups.cursor).to be

      next_plan_groups = plan_groups.next(per_page: 3)
      expect(next_plan_groups.has_more).to be(false)
    end

    it 'updates existing plan group name', uses_api: true do
      new_name = 'A new plan group_name'
      plan_group.name = new_name

      plan_group.update!

      api_pg = ChartMogul::PlanGroup.retrieve(plan_group.uuid)

      expect(api_pg.name).to eq(new_name)
      expect(api_pg.plans_count).to eq(2)
    end

    it 'updates existing plan group name via class method', uses_api: true, match_requests_on: [:method, :uri, :body] do
      new_name = 'A new group name'

      updated_pg = described_class.update!(plan_group.uuid, {
        name: new_name
      })

      expect(updated_pg.name).to eq(new_name)
      expect(updated_pg.plans_count).to eq(2)
    end

    it 'updates existing plan group plans', uses_api: true do
      plan3 = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A another Test Plan',
        data_source_uuid: data_source.uuid
      )
      new_plans = [plan1, plan2, plan3]
      plan_group.plans = new_plans

      plan_group.update!

      api_pg = ChartMogul::PlanGroup.retrieve(plan_group.uuid)
      plans = ChartMogul::PlanGroups::Plans.all(plan_group_uuid: plan_group.uuid)

      expect(api_pg.plans_count).to eq(3)
      expect(plans.map(&:uuid).sort).to eq(new_plans.map(&:uuid).sort)
    end

    it 'deletes a plan group' do
      plan_group.destroy!

      expect do
        ChartMogul::PlanGroup.retrieve(plan_group.uuid)
      end.to raise_error(ChartMogul::NotFoundError)
    end
  end
end
