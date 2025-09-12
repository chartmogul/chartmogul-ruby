# frozen_string_literal: true

module ChartMogul
  module CSV
    class MrrIntervalEdit < Base
      CONNECTION_HEADERS = %w[Account\ ID Billing\ Connector\ ID Customer\ External\ ID Subscription\ External\ ID Subscription\ Activation\ Number\ Interval\ Start\ Date Edited\ MRR Timestamp Auth\ User\ ID Email Edit\ Type].freeze

      writeable_attr :account_id
      writeable_attr :billing_connector_id
      writeable_attr :customer_external_id
      writeable_attr :subscription_external_id
      writeable_attr :subscription_activation_number
      writeable_attr :interval_start_date
      writeable_attr :edited_mrr
      writeable_attr :timestamp
      writeable_attr :auth_user_id
      writeable_attr :email
      writeable_attr :edit_type

      def self.headers
        CONNECTION_HEADERS
      end
    end
  end
end
