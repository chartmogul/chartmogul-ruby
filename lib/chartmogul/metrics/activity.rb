# frozen_string_literal: true

module ChartMogul
  module Metrics
    class Activity < ChartMogul::Object
      readonly_attr :description
      readonly_attr :type
      readonly_attr :date, type: :time
      readonly_attr :activity_arr
      readonly_attr :activity_mrr
      readonly_attr :activity_mrr_movement
      readonly_attr :currency
      readonly_attr :subscription_external_id
      readonly_attr :subscription_set_external_id
      readonly_attr :plan_external_id
      readonly_attr :customer_name
      readonly_attr :customer_uuid
      readonly_attr :customer_external_id
      readonly_attr :billing_connector_uuid
      readonly_attr :uuid

      def self.all(options = {})
        ChartMogul::Metrics::Activities.all(options)
      end
    end

    class Activities < APIResource
      set_resource_name 'Activities'
      set_resource_path '/v1/activities'

      include Concerns::Entries
      include Concerns::PageableWithAnchor
      include Concerns::PageableWithCursor

      set_entry_class Activity
    end
  end
end
