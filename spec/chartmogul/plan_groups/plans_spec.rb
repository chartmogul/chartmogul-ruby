# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::PlanGroups::Plans do
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

    it 'given a plan group uuid, returns an array of plans in the plan group', uses_api: true do
      plans = ChartMogul::PlanGroups::Plans.all(plan_group_uuid: plan_group.uuid)

      expect(plans.map(&:uuid).sort).to eq([plan1.uuid, plan2.uuid].sort)
    end
  end
end
