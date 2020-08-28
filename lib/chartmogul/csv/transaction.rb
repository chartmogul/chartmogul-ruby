# frozen_string_literal: true

module ChartMogul
  module CSV
    # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/05_Transactions.csv
    TRANSACTION_FIELDS = %i[invoice_external_id external_id type result date].freeze
    TRANSACTION_HEADERS = %w[Invoice\ external\ ID External\ ID Type Result Date].freeze

    Transaction = Struct.new(*ChartMogul::CSV::TRANSACTION_FIELDS) do
      include BaseStruct
      extend CSVHeader

      def self.headers
        TRANSACTION_HEADERS
      end

      def self.fields
        TRANSACTION_FIELDS
      end
    end
  end
end
