# frozen_string_literal: true

module ChartMogul
  module DataSourceSettings
    class ProcessingStatus < ChartMogul::Object
      readonly_attr :processed
      readonly_attr :pending
      readonly_attr :failed
    end
  end
end
