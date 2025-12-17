# frozen_string_literal: true

module ChartMogul
  module Concerns
    module AutoChurnSubscriptionSetting
      def self.included(base)
        base.send :prepend, InstanceMethods

        base.instance_eval do
          readonly_attr :auto_churn_subscription_setting
        end
      end

      module InstanceMethods
        def set_auto_churn_subscription_setting(auto_churn_subscription_setting_attributes)
          @auto_churn_subscription_setting = ChartMogul::DataSourceSettings::AutoChurnSubscriptionSetting.new_from_json(auto_churn_subscription_setting_attributes) if auto_churn_subscription_setting_attributes
        end
      end
    end
  end
end
