# frozen_string_literal: true

module ChartMogul
  module CSV
    INVOICE_FIELDS = %i[customer_external_id external_id date due_date currency].freeze
    INVOICE_HEADERS = %w[Customer\ external\ ID Invoice\ external\ ID Invoiced\ date Due\ date Currency].freeze

    Invoice = Struct.new(*ChartMogul::CSV::INVOICE_FIELDS) do
      include BaseStruct
      extend CSVHeader

      def self.headers
        INVOICE_HEADERS
      end

      def self.fields
        INVOICE_FIELDS
      end
    end
  end
end
