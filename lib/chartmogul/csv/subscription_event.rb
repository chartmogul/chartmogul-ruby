# frozen_string_literal: true

module ChartMogul
  module CSV
    class SubscriptionEvent < Base
      SUBSCRIPTION_EVENT_HEADERS = %w[External\ ID Subscription\ set\ external\ ID Subscription\ external\ ID Customer\ external\ ID Plan\ external\ ID Date Effective\ Date Event\ Type Currency Amount\ in\ Cents Quantity Retracted\ event\ ID Event\ Order].freeze

      # https://github.com/chartmogul/platform/blob/main/engines/data_ingestion/app/services/data_ingestion/csv_mapping/subscription_event.rb
      writeable_attr :external_id
      writeable_attr :subscription_set_external_id
      writeable_attr :subscription_external_id
      writeable_attr :data_source_customer_external_id
      writeable_attr :plan_external_id
      writeable_attr :event_date
      writeable_attr :effective_date
      writeable_attr :event_type
      writeable_attr :currency
      writeable_attr :amount_in_cents
      writeable_attr :quantity
      writeable_attr :retracted_event_id
      writeable_attr :event_order

      def self.headers
        SUBSCRIPTION_EVENT_HEADERS
      end
    end
  end
end
