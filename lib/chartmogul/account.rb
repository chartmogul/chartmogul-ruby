# frozen_string_literal: true

module ChartMogul
  class Account < APIResource
    set_resource_name 'Account'
    set_resource_path '/v1/account'

    readonly_attr :name
    readonly_attr :currency
    readonly_attr :time_zone
    readonly_attr :week_start_on

    # Optional attributes returned when using the include parameter
    readonly_attr :churn_recognition
    readonly_attr :churn_when_zero_mrr
    readonly_attr :auto_churn_subscription
    readonly_attr :refund_handling
    readonly_attr :proximate_movement_reclassification

    VALID_INCLUDE_FIELDS = %w[
      churn_recognition
      churn_when_zero_mrr
      auto_churn_subscription
      refund_handling
      proximate_movement_reclassification
    ].freeze

    include API::Actions::Custom

    def self.retrieve(include: nil)
      path = '/v1/account'
      if include
        fields = Array(include).join(',')
        path += "?include=#{fields}"
      end
      custom!(:get, path)
    end
  end
end
