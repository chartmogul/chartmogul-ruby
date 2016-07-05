module ChartMogul
  module Metrics
    class Activity < ChartMogul::Object
      readonly_attr :id
      readonly_attr :description
      readonly_attr :type
      readonly_attr :date, type: :time
      readonly_attr :activity_arr
      readonly_attr :activity_mrr
      readonly_attr :activity_mrr_movement
      readonly_attr :currency
      readonly_attr :currency_sign

      def self.all(customer_uuid, options = {})
        ChartMogul::Metrics::Activities.all(customer_uuid, options)
      end
    end

    class Activities < APIResource
      set_resource_name 'Activities'
      set_resource_path '/v1/customers/:customer_uuid/activities'

      include Concerns::Entries
      include Concerns::Pageable

      set_entry_class Activity

      def self.all(customer_uuid, options = {})
        super(options.merge(customer_uuid: customer_uuid))
      end
    end
  end
end

