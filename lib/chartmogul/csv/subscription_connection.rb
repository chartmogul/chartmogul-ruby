# frozen_string_literal: true

module ChartMogul
  module CSV
    class SubscriptionConnection < Base
      CONNECTION_HEADERS = %w[Primary\ Subscription\ ID Primary\ Billing\ Connector\ ID Connected\ Subscription\ ID Connected\ Billing\ Connector\ ID].freeze

      writeable_attr :primary_subscription_external_id
      writeable_attr :primary_subscription_activation_number
      writeable_attr :connected_subscription_external_id
      writeable_attr :connected_subscription_activation_number
      writeable_attr :primary_billing_connector_id
      writeable_attr :primary_customer_external_id
      writeable_attr :connected_billing_connector_id
      writeable_attr :connected_customer_external_id

      def self.headers
        CONNECTION_HEADERS
      end
    end
  end
end
