# frozen_string_literal: true

module ChartMogul
  class ReincludedCustomer < ChartMogul::Object
    readonly_attr :customer_uuid
    readonly_attr :status
  end
end
