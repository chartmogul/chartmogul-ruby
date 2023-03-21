# frozen_string_literal: true

module ChartMogul
  module CSV
    class Cancellation < Base
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/06_Cancellations.csv
      CANCELLATION_HEADERS = %w[Subscription\ external\ ID Customer\ external\ ID Date Invoice\ external\ ID Event\ Order].freeze

      writeable_attr :subscription_external_id
      writeable_attr :data_source_customer_external_id
      writeable_attr :cancelled_at
      writeable_attr :invoice_external_id
      writeable_attr :event_order

      def self.headers
        CANCELLATION_HEADERS
      end
    end
  end
end
