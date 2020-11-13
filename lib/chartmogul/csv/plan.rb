# frozen_string_literal: true

module ChartMogul
  module CSV
    class Plan < Base
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/02_Plans.csv
      PLAN_HEADERS = %w[Name Interval\ count Interval\ unit Plan\ ID].freeze

      writeable_attr :name
      writeable_attr :interval_count
      writeable_attr :interval_unit
      writeable_attr :external_id

      def self.headers
        PLAN_HEADERS
      end
    end
  end
end
