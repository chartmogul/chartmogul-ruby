# frozen_string_literal: true

module ChartMogul
  module DataSourceSettings
    class AutoChurnSubscriptionSetting < ChartMogul::Object
      readonly_attr :enabled
      readonly_attr :interval
    end
  end
end
