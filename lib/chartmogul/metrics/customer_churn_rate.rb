module ChartMogul
  module Metrics
    class CustomerChurnRate < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :customer_churn_rate
    end

    class CustomerChurnRates < APIResource
      set_resource_name 'Customer Churn Rates'
      set_resource_path '/v1/metrics/customer-churn-rate'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class CustomerChurnRate
    end
  end
end
