# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/04_Invoice_line_items.csv
      SUBSCRIPTION_HEADERS = %w[Invoice\ external\ ID External\ ID Subscription\ external\ ID Subscription\ set\ external\ ID Type Amount\ in\ cents Plan Service\ period\ start Service\ period\ end Quantity Proration Discount\ code Discount\ amount Tax\ amount Description Transaction\ fee Account\ Code].freeze

      class Subscription < Base

        writeable_attr :invoice_external_id
        writeable_attr :external_id
        writeable_attr :subscription_external_id
        writeable_attr :subscription_set_external_id
        writeable_attr :type
        writeable_attr :amount_in_cents
        writeable_attr :plan_external_id
        writeable_attr :service_period_start
        writeable_attr :service_period_end
        writeable_attr :quantity
        writeable_attr :prorated
        writeable_attr :discount_code
        writeable_attr :discount_amount_in_cents
        writeable_attr :tax_amount_in_cents
        writeable_attr :description
        writeable_attr :transaction_fees_in_cents
        writeable_attr :account_code

        def type
          'subscription'
        end

        def self.headers
          ChartMogul::CSV::LineItems::SUBSCRIPTION_HEADERS
        end
      end
    end
  end
end
