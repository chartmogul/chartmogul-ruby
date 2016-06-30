module ChartMogul
  module Metrics
    class ArpaEntity < APIResource
      set_resource_name 'ARPA'

      readonly_attr :date, type: :date
      readonly_attr :arpa
    end

    class ArpaEntries < APIResource
      set_resource_name 'ARPA'
      set_resource_path '/v1/metrics/arpa'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class ArpaEntity
    end
  end
end

