module ChartMogul
  module Metrics
    class AllKeyMetric < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :arpa
      readonly_attr :arr
      readonly_attr :asp
      readonly_attr :customer_churn_rate
      readonly_attr :customers
      readonly_attr :ltv
      readonly_attr :mrr
      readonly_attr :mrr_churn_rate
    end

    class AllKeyMetrics < APIResource
      set_resource_name 'All Key Metrics'
      set_resource_path '/v1/metrics/all'

      include Concerns::Entries

      set_entry_class AllKeyMetric
    end
  end
end
