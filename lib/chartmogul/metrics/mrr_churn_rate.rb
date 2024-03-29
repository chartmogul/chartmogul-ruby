# frozen_string_literal: true

module ChartMogul
  module Metrics
    class MRRChurnRate < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :mrr_churn_rate
      readonly_attr :percentage_change
    end

    class MRRChurnRates < APIResource
      set_resource_name 'MRR Churn Rates'
      set_resource_path '/v1/metrics/mrr-churn-rate'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class MRRChurnRate
    end
  end
end
