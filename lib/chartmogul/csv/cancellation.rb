# frozen_string_literal: true

module ChartMogul
  module CSV
    # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/06_Cancellations.csv
    CANCELLATION_FIELDS = %i[subscription_external_id customer_external_id date].freeze
    CANCELLATION_HEADERS = %w[Subscription\ external\ ID Customer\ external\ ID Date].freeze

    Cancellation = Struct.new(*ChartMogul::CSV::CANCELLATION_FIELDS) do
      include BaseStruct
      extend CSVHeader

      def self.headers
        CANCELLATION_HEADERS
      end

      def self.fields
        CANCELLATION_FIELDS
      end
    end
  end
end
