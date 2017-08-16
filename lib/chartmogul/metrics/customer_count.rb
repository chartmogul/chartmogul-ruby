module ChartMogul
  module Metrics
    class CustomerCount < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :customers
    end

    class CustomerCounts < APIResource
      set_resource_name 'Customer Counts'
      set_resource_path '/v1/metrics/customer-count'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class CustomerCount
    end
  end
end
