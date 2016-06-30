module ChartMogul
  module Metrics
    class AllKeyMetricsEntity < APIResource
      set_resource_name 'All metrics'

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

    class AllKeyMetricsEntries < APIResource
      set_resource_name 'All metrics entries'
      set_resource_path '/v1/metrics/all'

      include Concerns::Entries

      set_entry_class AllKeyMetricsEntity
    end
  end
end

