# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/04_Invoice_line_items.csv
      SUBSCRIPTION_FIELDS = %i[invoice_external_id external_id subscription_external_id subscription_set_external_id type amount_in_cents plan_external_id service_period_start service_period_end quantity prorated discount_code discount_amount_in_cents tax_amount_in_cents description transaction_fees_in_cents account_code].freeze
      SUBSCRIPTION_HEADERS = %w[Invoice\ external\ ID External\ ID Subscription\ external\ ID Subscription\ set\ external\ ID Type Amount\ in\ cents Plan Service\ period\ start Service\ period\ end Quantity Proration Discount\ code Discount\ amount Tax\ amount Description Transaction\ fee Account\ Code].freeze

      Subscription = Struct.new(*ChartMogul::CSV::LineItems::SUBSCRIPTION_FIELDS) do
        include BaseStruct
        extend CSVHeader

        def type
          'subscription'
        end

        def self.headers
          SUBSCRIPTION_HEADERS
        end

        def self.fields
          SUBSCRIPTION_FIELDS
        end
      end
    end
  end
end
