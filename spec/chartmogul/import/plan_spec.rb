require 'spec_helper'

describe ChartMogul::Import::Plan do
  describe 'API Interractions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::Import::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Import::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )

      plans = ChartMogul::Import::Plan.all

      expect(plans.size).to eq(1)
      expect(plans[0].name).to eq(plan.name)
      expect(plans[0].external_id).to eq(plan.external_id)
      expect(plans[0].interval_unit).to eq(plan.interval_unit)
      expect(plans[0].interval_count).to eq(plan.interval_count)
      expect(plans[0].data_source_uuid).to eq(plan.data_source_uuid)
    end

    it 'correctly handles a 422 error', uses_api: true do
      expect { ChartMogul::Import::Plan.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'retrieves existing plan by uuid', uses_api: true do
      data_source = ChartMogul::Import::DataSource.create!(name:"Another Data Source")

      plan = ChartMogul::Import::Plan.create!(
        interval_count: 1,
        interval_unit: "month",
        name: "A Test Plan",
        data_source_uuid: data_source.uuid
      )
      plan.send(:set_uuid, 'pl_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      plan = described_class.retrieve(plan.uuid)
      expect(plan).to be
    end
  end
end
