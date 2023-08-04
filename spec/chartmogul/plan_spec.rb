# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Plan do
  describe 'API Interactions', vcr: true do
    it 'creates a plan correctly', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name: 'Another Data Source')

      plan = described_class.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A Test Plan',
        data_source_uuid: data_source.uuid
      )

      expect(plan.uuid).to eq("pl_e74b6560-14e2-013c-950e-7ab51896fb00")
      expect(plan.data_source_uuid).to eq(data_source.uuid)
    end

    it 'correctly handles a 422 error', uses_api: true do
      expect { ChartMogul::Plan.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'retrieves existing plan by uuid', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name: 'Another Data Source')

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A Test Plan',
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      plan = described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')
      expect(plan).to be
    end

    it 'paginates correctly', uses_api: true do
      plans = described_class.all(per_page: 1)
      expect(plans.has_more).to be(true)
      expect(plans.cursor).to be

      next_plans = plans.next(per_page: 3)
      expect(next_plans.has_more).to be(false)
    end

    it 'updates existing plan', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name: 'Another Data Source')

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A Test Plan',
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      plan.interval_count = 2
      plan.update!

      plan = described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')
      expect(plan.interval_count).to eq(2)
    end

    it 'updates existing plan using class method', uses_api: true, match_requests_on: [:method, :uri, :body] do
      data_source = ChartMogul::DataSource.create!(name: 'Another Data Source')

      plan = described_class.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'pro',
        data_source_uuid: data_source.uuid
      )

      updated_plan = described_class.update!(plan.uuid, {
        interval_count: 2,
        name: 'really pro'
      })

      expect(updated_plan.interval_count).to eq(2)
      expect(updated_plan.name).to eq('really pro')
    end

    it 'deletes existing plan', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name: 'Another Data Source')

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: 'month',
        name: 'A Test Plan',
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      expect(plan.destroy!).to be_truthy
      expect { described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072') }.to raise_error(ChartMogul::NotFoundError)
    end
  end
end
