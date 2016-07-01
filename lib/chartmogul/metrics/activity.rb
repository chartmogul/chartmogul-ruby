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

      def self.all(options = {})
        ChartMogul::Metrics::Activities.all(options)
      end
    end

    class Activities < APIResource
      set_resource_name 'Activities'
      set_resource_path '/v1/customers/:customer_uuid/activities'

      writeable_attr :customer_uuid

      include Concerns::Entries
      include Concerns::Pageable

      set_entry_class Activity
    end
  end
end

