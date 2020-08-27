# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CSV::Plan do
  describe '#initialize' do
    subject(:csv_plan) do
      described_class.new(
        name: 'Premuim Monthly Plan',
        external_id: 'plan_id',
        interval_count: 1,
        interval_unit: 'month'
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
      expect(csv_plan.interval_unit).to eq('month')
    end

    it 'returns a struct' do
      expect(csv_plan).to be_a(Struct)
    end
  end

  describe '#csv_file_headers' do
    subject(:headers) { described_class.csv_file_headers }

    it 'returns a struct' do
      expect(headers).to be_a(Struct)
    end

    it 'returns the correct headers' do
      expect(headers.to_a).to eq(['Name', 'Interval count', 'Interval unit', 'Plan ID'])
    end
  end
end
