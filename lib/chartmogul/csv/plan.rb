# frozen_string_literal: true

module ChartMogul
  module CSV
    # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/02_Plans.csv
    PLAN_FIELDS = %i[name interval_count interval_unit external_id].freeze
    PLAN_HEADERS = %w[Name Interval\ count Interval\ unit Plan\ ID].freeze

    Plan = Struct.new(*ChartMogul::CSV::PLAN_FIELDS) do
      include BaseStruct
      extend CSVHeader

      def self.headers
        PLAN_HEADERS
      end

      def self.fields
        PLAN_FIELDS
      end
    end
  end
end
