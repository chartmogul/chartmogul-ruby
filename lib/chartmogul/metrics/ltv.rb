module ChartMogul
  module Metrics
    class LTV < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :ltv
    end

    class LTVs < APIResource
      set_resource_name 'LTVs'
      set_resource_path '/v1/metrics/ltv'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class LTV
    end
  end
end
