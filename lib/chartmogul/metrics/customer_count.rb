module ChartMogul
  module Metrics
    class CustomerCountEntity < APIResource
      set_resource_name 'Customer Count'

      readonly_attr :date, type: :date
      readonly_attr :customers
    end

    class CustomerCountEntries < APIResource
      set_resource_name 'Customer Count'
      set_resource_path '/v1/metrics/customer-count'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class CustomerCountEntity
    end
  end
end

