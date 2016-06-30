module ChartMogul
  module Metrics
    class Summary < APIResource
      set_resource_name 'Summary'

      readonly_attr :current
      readonly_attr :previous
      readonly_attr :percentage_change
    end
  end
end

