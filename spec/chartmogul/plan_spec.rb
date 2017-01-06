require 'spec_helper'

describe ChartMogul::Plan do
  describe 'API Interractions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )

      plans = ChartMogul::Plan.all

      expect(plans.size).to eq(1)
      expect(plans[0].name).to eq(plan.name)
      expect(plans[0].external_id).to eq(plan.external_id)
      expect(plans[0].interval_unit).to eq(plan.interval_unit)
      expect(plans[0].interval_count).to eq(plan.interval_count)
      expect(plans[0].data_source_uuid).to eq(plan.data_source_uuid)
    end

    it 'correctly handles a 422 error', uses_api: true do
      expect { ChartMogul::Plan.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'retrieves existing plan by uuid', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      plan = described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')
      expect(plan).to be
    end

    it 'updates existing plan', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      plan.interval_count = 2
      plan.update!

      plan = described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')
      expect(plan.interval_count).to eq(2)
    end

    it 'deletes existing plan', uses_api: true do
      data_source = ChartMogul::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      expect(plan.destroy!).to be_truthy
      expect { described_class.retrieve('pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072') }.to raise_error(ChartMogul::NotFoundError)
    end
  end
end
