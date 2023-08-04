# frozen_string_literal: true

module ChartMogul
  class Subscription < APIResource
    set_resource_name 'Subscription'
    set_resource_path '/v1/import/customers/:customer_uuid/subscriptions'

    readonly_attr :uuid
    writeable_attr :external_id
    writeable_attr :subscription_set_external_id
    readonly_attr :cancellation_dates, default: []

    readonly_attr :plan_uuid
    writeable_attr :data_source_uuid
    readonly_attr :customer_uuid

    include API::Actions::Custom

    def update_cancellation_dates(cancellation_dates_array)
      cancellation_dates = parse_dates(cancellation_dates_array)
      custom!(:patch, "/v1/import/subscriptions/#{uuid}", cancellation_dates: cancellation_dates)
    end

    def cancel(cancelled_at)
      custom!(:patch, "/v1/import/subscriptions/#{uuid}", cancelled_at: cancelled_at)
    end

    def connect(customer_uuid, subscriptions)
      subscriptions.unshift(self)
      custom!(:post, "/v1/customers/#{customer_uuid}/connect_subscriptions", subscriptions: subscriptions.map(&:serialize_for_write))
    end

    def self.all(customer_uuid, options = {})
      Subscriptions.all(customer_uuid, options)
    end

    private

    def set_cancellation_dates(cancellation_dates_array)
      @cancellation_dates = parse_dates(cancellation_dates_array)
    end

    def parse_dates(dates)
      dates.map { |date| Time.parse(date.to_s) }
    end
  end

  class Subscriptions < APIResource
    readonly_attr :customer_uuid

    set_resource_name 'Subscriptions'
    set_resource_path '/v1/import/customers/:customer_uuid/subscriptions'

    set_resource_root_key :subscriptions

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Subscription

    def self.all(customer_uuid, options = {})
      super(options.merge(customer_uuid: customer_uuid))
    end
  end
end
