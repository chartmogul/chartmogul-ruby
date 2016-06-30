module ChartMogul
  module Metrics
    class Activity < APIResource
      set_resource_name 'Activity'

      readonly_attr :id
      readonly_attr :description
      readonly_attr :type
      readonly_attr :activity_arr
      readonly_attr :activity_mrr
      readonly_attr :activity_mrr_movement
      readonly_attr :currency
      readonly_attr :currency_sign
    end

    class ActivityEntries < APIResource
      set_resource_name 'Activities'
      set_resource_path '/v1/customers/:customer_uuid/activities'

      writeable_attr :customer_uuid

      include Concerns::Entries
      set_entry_class Activity
    end
  end
end

