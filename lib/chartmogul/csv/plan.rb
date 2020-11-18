# frozen_string_literal: true

module ChartMogul
  module CSV
    class Plan < Base
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/02_Plans.csv
      PLAN_HEADERS = %w[Name Interval\ count Interval\ unit Plan\ ID].freeze

      # https://github.com/chartmogul/platform/blob/main/engines/data_ingestion/app/services/data_ingestion/csv_mapping/plan.rb
      writeable_attr :name
      writeable_attr :interval_count
      writeable_attr :interval
      writeable_attr :external_id

      def self.headers
        PLAN_HEADERS
      end
    end
  end
end
