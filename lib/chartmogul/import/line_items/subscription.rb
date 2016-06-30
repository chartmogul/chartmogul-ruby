module ChartMogul
  module Import
    module LineItems
      class Subscription < ChartMogul::Object
        readonly_attr :uuid

        writeable_attr :type, default: 'subscription'
        writeable_attr :subscription_external_id
        writeable_attr :service_period_start, type: :time
        writeable_attr :service_period_end, type: :time
        writeable_attr :amount_in_cents
        writeable_attr :cancelled_at, type: :time
        writeable_attr :prorated
        writeable_attr :quantity
        writeable_attr :discount_amount_in_cents
        writeable_attr :discount_code
        writeable_attr :tax_amount_in_cents
        writeable_attr :external_id

        readonly_attr :subscription_uuid
        writeable_attr :invoice_uuid
        writeable_attr :plan_uuid

        def initialize(attributes = {})
          super(attributes)
          @type = 'subscription'
        end
      end
    end
  end
end
