# frozen_string_literal: true

module ChartMogul
  module Metrics
    module Customers
      class Subscription < ChartMogul::Object
        readonly_attr :id
        readonly_attr :uuid
        readonly_attr :external_id
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
          ChartMogul::Metrics::Customers::Subscriptions.all(customer_uuid, options)
        end

        def connect(data_source_uuid, customer_uuid, subscriptions)
          subscriptions.unshift(self)
          ChartMogul::Metrics::Customers::Subscriptions.connect(data_source_uuid, customer_uuid, subscriptions)
        end

        def disconnect(data_source_uuid, customer_uuid, subscriptions)
          subscriptions.unshift(self)
          ChartMogul::Metrics::Customers::Subscriptions.disconnect(data_source_uuid, customer_uuid, subscriptions)
        end
      end

      class Subscriptions < APIResource
        set_resource_name 'Subscriptions'
        set_resource_path '/v1/customers/:customer_uuid/subscriptions'

        include API::Actions::Custom
        include Concerns::Entries
        include Concerns::Pageable
        include Concerns::PageableWithCursor

        set_entry_class Subscription

        def self.all(customer_uuid, options = {})
          super(options.merge(customer_uuid: customer_uuid))
        end

        def self.connect(data_source_uuid, customer_uuid, subscriptions)
          custom!(:post,
                  "/v1/customers/#{customer_uuid}/connect_subscriptions",
                  connect_disconnect_body(data_source_uuid, subscriptions))
        end

        def self.disconnect(data_source_uuid, customer_uuid, subscriptions)
          custom!(:post,
                  "/v1/customers/#{customer_uuid}/disconnect_subscriptions",
                  connect_disconnect_body(data_source_uuid, subscriptions))
        end

        def self.connect_disconnect_body(data_source_uuid, subscriptions)
          {
            subscriptions: subscriptions.uniq.map do |subscription|
              {
                data_source_uuid: data_source_uuid,
                uuid: subscription.uuid
              }
            end
          }
        end

        def next(customer_uuid, options = {})
          Subscriptions.all(customer_uuid, options.merge(cursor: cursor))
        end
      end
    end
  end
end
