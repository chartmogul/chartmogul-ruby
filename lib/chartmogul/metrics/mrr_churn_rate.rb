require 'forwardable'

module ChartMogul
  module Metrics
    class MrrChurnRateEntity < APIResource
      set_resource_name 'MRR Churn Rate'

      readonly_attr :date, type: :date
      readonly_attr :mrr_churn_rate
    end

    class MrrChurnRateEntries < APIResource
      extend Forwardable
      include Enumerable

      set_resource_name 'MRR Churn Rates'
      set_resource_path '/v1/metrics/mrr-churn-rate'

      include Entries
      set_entry_class MrrChurnRateEntity
    end
  end
end

