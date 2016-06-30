module ChartMogul
  module Metrics
    class Subscription < APIResource
      set_resource_name 'Subscription'

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
    end

    class SubscriptionEntries < APIResource
      set_resource_name 'Subscriptions'
      set_resource_path '/v1/customers/:customer_uuid/subscriptions'

      writeable_attr :customer_uuid

      include Concerns::Entries
      include Concerns::Pageable

      set_entry_class Subscription
    end
  end
end

