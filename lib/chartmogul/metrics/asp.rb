require 'forwardable'

module ChartMogul
  module Metrics
    class AspEntity < APIResource
      set_resource_name 'ASP'

      readonly_attr :date, type: :date
      readonly_attr :asp
    end

    class AspEntries < APIResource
      set_resource_name 'ASP'
      set_resource_path '/v1/metrics/asp'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class AspEntity
    end
  end
end

