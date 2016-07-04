module ChartMogul
  module Import
    class Subscription < APIResource
      set_resource_name 'Subscription'
      set_resource_path '/v1/import/customers/:customer_uuid/subscriptions'
      set_resource_root_key :subscriptions

      readonly_attr :uuid
      readonly_attr :external_id
      readonly_attr :cancellation_dates, default: []

      readonly_attr :plan_uuid
      readonly_attr :data_source_uuid
      readonly_attr :customer_uuid

      include API::Actions::All
      include API::Actions::Custom

      def set_cancellation_dates(cancellation_dates_array)
        @cancellation_dates = cancellation_dates_array.map do |cancellation_date|
          Time.parse(cancellation_date)
        end
      end

      def cancel(cancelled_at)
        custom!(:patch, "/v1/import/subscriptions/#{uuid}", cancelled_at: cancelled_at)
      end

      def self.all(customer_uuid, options = {})
        super(options.merge(customer_uuid: customer_uuid))
      end
    end
  end
end
