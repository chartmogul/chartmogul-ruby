# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChartMogul::Metrics::ActivitiesExport do
  describe 'API interactions', vcr: true, uses_api: true do
    describe '#create!' do
      it 'returns a pending activity export', vcr: 'ChartMogul_Metrics_ActivitiesExport/post_activities_export' do
        activities_export = ChartMogul::Metrics::ActivitiesExport.create!(
          start_date: Time.parse('2020-01-01').to_s,
          end_date: Time.parse('2020-12-31').to_s,
          type: 'new_biz'
        )

        expect(activities_export.status).to eq('pending')
        expect(activities_export.file_url).to be_nil

        # the async export must be reloaded periodically until it is sucessful or fails permanently
        activities_export = activities_export.reload

        expect(activities_export.status).to eq('succeeded')
        expect(activities_export.file_url).not_to be_nil
      end
    end

    describe '#retrieve', vcr: 'ChartMogul_Metrics_ActivitiesExport/get_activities_export' do
      it 'returns the finished activity export' do
        activities_export = ChartMogul::Metrics::ActivitiesExport.retrieve('44037b8f-4a89-4fc6-8114-2288c71a9518')
        expect(activities_export.status).to eq('succeeded')
        expect(activities_export.file_url).not_to be_nil
      end
    end
  end
end
