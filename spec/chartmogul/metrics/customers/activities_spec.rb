# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Metrics::Customers::Activity do
  describe 'API interactions', vcr: true do
    it 'retrieves the activities correctly', uses_api: true do
      response = ChartMogul::Metrics::Customers::Activity.all('cus_96e20c1b-b986-48d7-8dbd-8ddd71e78fc7')

      expect(response).to be_a(ChartMogul::Metrics::Customers::Activities)
      expect(response.count).to be(3)
      response.each do |activity|
        expect(activity).to be_a(ChartMogul::Metrics::Customers::Activity)
      end
    end

    it 'paginates correctly', uses_api: true do
      activities = ChartMogul::Metrics::Customers::Activity.all('cus_96e20c1b-b986-48d7-8dbd-8ddd71e78fc7', per_page: 1)
      expect(activities.has_more).to be(true)
      expect(activities.cursor).to be

      next_activities = activities.next('cus_96e20c1b-b986-48d7-8dbd-8ddd71e78fc7', per_page: 3)
      expect(next_activities.has_more).to be(false)
    end
  end
end
