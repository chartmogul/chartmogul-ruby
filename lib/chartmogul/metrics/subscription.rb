module ChartMogul
  module Metrics
    class Subscription < ChartMogul::Object
      readonly_attr :id
      readonly_attr :plan
      readonly_attr :quantity
      readonly_attr :mrr
      readonly_attr :arr
      readonly_attr :status
      readonly_attr :billing_cycle
      readonly_attr :billing_cycle_count
      readonly_attr :start_date, type: :time
      readonly_attr :end_date, type: :time
      readonly_attr :currency
      readonly_attr :currency_sign

      def self.all(customer_uuid, options = {})
        ChartMogul::Metrics::Subscriptions.all(customer_uuid, options)
      end
    end

    class Subscriptions < APIResource
      set_resource_name 'Subscriptions'
      set_resource_path '/v1/customers/:customer_uuid/subscriptions'

      include Concerns::Entries
      include Concerns::Pageable

      set_entry_class Subscription

      def self.all(customer_uuid, options = {})
        super(options.merge(customer_uuid: customer_uuid))
      end
    end
  end
end

