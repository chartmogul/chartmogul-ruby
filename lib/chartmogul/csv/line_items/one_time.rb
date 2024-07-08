# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      class OneTime < Base
        HEADERS = %w[Invoice\ external\ ID External\ ID Subscription\ external\ ID Subscription\ set\ external\ ID Type Amount\ in\ cents Plan Service\ period\ start Service\ period\ end Quantity Proration Discount\ code Discount\ amount Tax\ amount Description Transaction\ fee Account\ Code Transaction\ fees\ currency Discount\ description Balance\ transfer].freeze

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
        writeable_attr :transaction_fees_currency
        writeable_attr :discount_description
        writeable_attr :balance_transfer

        def type
          'one_time'
        end

        def self.headers
          HEADERS
        end
      end
    end
  end
end
