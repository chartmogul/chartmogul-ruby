# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::PlanGroup do
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

    it 'returns an array of plan groups' do
      plan_group

      plan3 = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A another Test Plan',
        data_source_uuid: data_source.uuid
      )

      second_plan_group = ChartMogul::PlanGroup.create!(
        name: 'My second plan group',
        plans: [plan2, plan3]
      )

      plan_groups = ChartMogul::PlanGroup.all

      expect(plan_groups.map(&:uuid).sort).to eq([plan_group.uuid, second_plan_group.uuid].sort)
      expect(plan_groups.map(&:plans_count)).to eq([2, 2])
    end

    it 'correctly handles a 422 error', uses_api: true do
      expect { ChartMogul::PlanGroup.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'retrieves existing plan group by uuid', uses_api: true do
      api_pg = ChartMogul::PlanGroup.retrieve(plan_group.uuid)

      expect(api_pg.uuid).to eq(plan_group.uuid)
    end

    it 'updates existing plan group name', uses_api: true do
      new_name = 'A new plan group_name'
      plan_group.name = new_name

      plan_group.update!

      api_pg = ChartMogul::PlanGroup.retrieve(plan_group.uuid)

      expect(api_pg.name).to eq(new_name)
      expect(api_pg.plans_count).to eq(2)
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
