# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      class OneTime < Base
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
        writeable_attr :discount_amount_in_cents
        writeable_attr :tax_amount_in_cents
        writeable_attr :description
        writeable_attr :transaction_fees_in_cents
        writeable_attr :account_code

        def type
          'one_time'
        end

        def self.headers
          ChartMogul::CSV::LineItems::SUBSCRIPTION_HEADERS
        end
      end
    end
  end
end
