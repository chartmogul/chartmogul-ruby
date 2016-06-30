module ChartMogul
  module Metrics
    class CustomerChurnRateEntity < APIResource
      set_resource_name 'Customer Churn Rate'

      readonly_attr :date, type: :date
      readonly_attr :customer_churn_rate
    end

    class CustomerChurnRateEntries < APIResource
      set_resource_name 'Customer Churn Rate'
      set_resource_path '/v1/metrics/customer-churn-rate'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class CustomerChurnRateEntity
    end
  end
end

