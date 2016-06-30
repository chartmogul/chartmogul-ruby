require 'forwardable'

module ChartMogul
  module Metrics
    class MrrEntity < APIResource
      set_resource_name 'MRR'

      readonly_attr :date, type: :date
      readonly_attr :mrr
      readonly_attr :mrr_new_business
      readonly_attr :mrr_expansion
      readonly_attr :mrr_churn
      readonly_attr :mrr_reactivation
    end

    class MrrEntries < APIResource
      set_resource_name 'MRR'
      set_resource_path '/v1/metrics/mrr'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class MrrEntity
    end
  end
end

