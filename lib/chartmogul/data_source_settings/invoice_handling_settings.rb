# frozen_string_literal: true

module ChartMogul
  module DataSourceSettings
    class InvoiceHandlingSettings < ChartMogul::Object
      readonly_attr :create_subscription_when_invoice_is
      readonly_attr :update_subscription_when_invoice_is
      readonly_attr :prevent_subscription_for_invoice_refunded
      readonly_attr :prevent_subscription_for_invoice_voided
      readonly_attr :prevent_subscription_for_invoice_written_off
    end
  end
end
