# frozen_string_literal: true

module ChartMogul
  module DataSourceSettings
    class InvoiceHandlingSetting < ChartMogul::Object
      readonly_attr :manual
      readonly_attr :automatic

      private

      def set_manual(invoice_handling_settings_attributes)
        @manual = InvoiceHandlingSettings.new_from_json(invoice_handling_settings_attributes) if invoice_handling_settings_attributes
      end

      def set_automatic(invoice_handling_settings_attributes)
        @automatic = InvoiceHandlingSettings.new_from_json(invoice_handling_settings_attributes) if invoice_handling_settings_attributes
      end
    end
  end
end
