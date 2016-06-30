require 'forwardable'

module ChartMogul
  module Metrics
    class LtvEntity < APIResource
      set_resource_name 'LTV'

      readonly_attr :date, type: :date
      readonly_attr :ltv
    end

    class LtvEntries < APIResource
      extend Forwardable
      include Enumerable

      set_resource_name 'LTV'
      set_resource_path '/v1/metrics/ltv'

      include Entries
      set_entry_class LtvEntity
    end
  end
end

