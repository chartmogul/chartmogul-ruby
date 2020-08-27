# frozen_string_literal: true

module ChartMogul
  module CSV
    # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/01_Customers.csv
    CUSTOMER_FIELDS = %i[name email company country state city zip external_id lead_created_at free_trial_started_at].freeze
    CUSTOMER_HEADERS = %w[Name Email Company Country State City Zip External\ ID Lead\ created\ at Free\ trial\ started\ at].freeze

    Customer = Struct.new(*ChartMogul::CSV:: CUSTOMER_FIELDS) do
      include BaseStruct
      extend CSVHeader

      def self.headers
        CUSTOMER_HEADERS
      end

      def self.fields
        CUSTOMER_FIELDS
      end
    end
  end
end

