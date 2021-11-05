# frozen_string_literal: true

module ChartMogul
  module CSV
    class Transaction < Base
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/05_Transactions.csv
      TRANSACTION_HEADERS = %w[Invoice\ external\ ID External\ ID Type Result Date Amount\ in\ cents Exclude\ tax\ on\ refund Exclude\ discount\ on\ refund Exclude\ fees\ on\ refund Transaction\ fee Transaction\ fees\ currency].freeze

      writeable_attr :invoice_external_id
      writeable_attr :external_id
      writeable_attr :type
      writeable_attr :result
      writeable_attr :transacted_at
      writeable_attr :amount_in_cents
      writeable_attr :exclude_tax_on_refund
      writeable_attr :exclude_discount_on_refund
      writeable_attr :exclude_fees_on_refund
      writeable_attr :transaction_fees_in_cents
      writeable_attr :transaction_fees_currency
      def self.headers
        TRANSACTION_HEADERS
      end
    end
  end
end
