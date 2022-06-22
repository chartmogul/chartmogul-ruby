# frozen_string_literal: true

module ChartMogul
  class SummaryAll < ChartMogul::Object
    readonly_attr :current_arpa
    readonly_attr :current_arr
    readonly_attr :current_asp
    readonly_attr :current_customer_churn_rate
    readonly_attr :current_customers
    readonly_attr :current_ltv
    readonly_attr :current_mrr
    readonly_attr :current_mrr_churn_rate
    readonly_attr :previous_arpa
    readonly_attr :previous_arr
    readonly_attr :previous_asp
    readonly_attr :previous_customer_churn_rate
    readonly_attr :previous_customers
    readonly_attr :previous_ltv
    readonly_attr :previous_mrr
    readonly_attr :previous_mrr_churn_rate
    readonly_attr :arpa_percentage_change
    readonly_attr :arr_percentage_change
    readonly_attr :asp_percentage_change
    readonly_attr :customer_churn_rate_percentage_change
    readonly_attr :customers_percentage_change
    readonly_attr :ltv_percentage_change
    readonly_attr :mrr_percentage_change
    readonly_attr :mrr_churn_rate_percentage_change
  end
end
