require 'forwardable'

module ChartMogul
  module Metrics
    class AspEntity < APIResource
      set_resource_name 'ASP'

      readonly_attr :date, type: :date
      readonly_attr :asp
    end

    class AspEntries < APIResource
      extend Forwardable
      include Enumerable

      set_resource_name 'ASP'
      set_resource_path '/v1/metrics/asp'

      include Entries
      set_entry_class AspEntity
    end
  end
end

