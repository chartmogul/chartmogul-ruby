# frozen_string_literal: true

module ChartMogul
  module CSV
    class Transaction < Base
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/05_Transactions.csv
      TRANSACTION_HEADERS = %w[Invoice\ external\ ID External\ ID Type Result Date Amount\ in\ cents No\ reverse\ tax No\ reverse\ discount No\ reverse\ transaction\ fee].freeze

      writeable_attr :invoice_external_id
      writeable_attr :external_id
      writeable_attr :type
      writeable_attr :result
      writeable_attr :transacted_at
      writeable_attr :amount_in_cents
      writeable_attr :no_reverse_tax
      writeable_attr :no_reverse_discount
      writeable_attr :no_reverse_transaction_fee
      def self.headers
        TRANSACTION_HEADERS
      end
    end
  end
end
