module ChartMogul
  module Metrics
    class MRR < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :mrr

      readonly_attr :mrr_new_business

      readonly_attr :mrr_expansion
      readonly_attr :mrr_contraction

      readonly_attr :mrr_churn
      readonly_attr :mrr_reactivation
    end

    class MRRs < APIResource
      set_resource_name 'MRRs'
      set_resource_path '/v1/metrics/mrr'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class MRR
    end
  end
end
