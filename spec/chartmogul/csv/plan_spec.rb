# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Plan do
  describe '#initialize' do
    subject(:csv_plan) do
      described_class.new(
        name: 'Premuim Monthly Plan',
        external_id: 'plan_id',
        interval_count: 1,
        interval: 'month'
      )
    end

    it 'sets correctly the plan name' do
      expect(csv_plan.name).to eq('Premuim Monthly Plan')
    end

    it 'sets correctly the external ID' do
      expect(csv_plan.external_id).to eq('plan_id')
    end

    it 'sets correctly the interval count' do
      expect(csv_plan.interval_count).to eq(1)
    end

    it 'sets correctly the interval unit' do
      expect(csv_plan.interval).to eq('month')
    end

    it 'returns the correct headers' do
      expect(described_class.headers).to eq(['Name', 'Interval count', 'Interval unit', 'Plan ID'])
    end
  end
end
