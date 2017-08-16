module ChartMogul
  module Metrics
    class ARR < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :arr
    end

    class ARRs < APIResource
      set_resource_name 'ARRs'
      set_resource_path '/v1/metrics/arr'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class ARR
    end
  end
end
