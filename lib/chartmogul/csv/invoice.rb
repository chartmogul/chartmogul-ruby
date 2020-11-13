# frozen_string_literal: true

module ChartMogul
  module CSV
    class Invoice < Base

      INVOICE_HEADERS = %w[Customer\ external\ ID Invoice\ external\ ID Invoiced\ date Due\ date Currency].freeze

      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/03_Invoices.csv
      writeable_attr :customer_external_id
      writeable_attr :external_id
      writeable_attr :date
      writeable_attr :due_date
      writeable_attr :currency

      def self.headers
        INVOICE_HEADERS
      end
    end
  end
end
