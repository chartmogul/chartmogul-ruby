require 'forwardable'

module ChartMogul
  module Metrics
    class ArrEntity < APIResource
      set_resource_name 'ARR'

      readonly_attr :date, type: :date
      readonly_attr :arr
    end

    class ArrEntries < APIResource
      extend Forwardable
      include Enumerable

      set_resource_name 'ARR'
      set_resource_path '/v1/metrics/arr'

      include Entries
      set_entry_class ArrEntity
    end
  end
end

