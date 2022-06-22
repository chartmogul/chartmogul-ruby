# frozen_string_literal: true

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
      readonly_attr :arpa_percentage_change
      readonly_attr :arr_percentage_change
      readonly_attr :asp_percentage_change
      readonly_attr :customer_churn_rate_percentage_change
      readonly_attr :customers_percentage_change
      readonly_attr :ltv_percentage_change
      readonly_attr :mrr_percentage_change
      readonly_attr :mrr_churn_rate_percentage_change
    end

    class AllKeyMetrics < APIResource
      set_resource_name 'All Key Metrics'
      set_resource_path '/v1/metrics/all'

      include Concerns::Entries
      include Concerns::SummaryAll

      set_entry_class AllKeyMetric
    end
  end
end
