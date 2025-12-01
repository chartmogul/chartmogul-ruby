# frozen_string_literal: true

module ChartMogul
  module Concerns
    module InvoiceHandlingSetting
      def self.included(base)
        base.send :prepend, InstanceMethods

        base.instance_eval do
          readonly_attr :invoice_handling_setting
        end
      end

      module InstanceMethods
        def set_invoice_handling_setting(invoice_handling_setting_attributes)
          @invoice_handling_setting = ChartMogul::DataSourceSettings::InvoiceHandlingSetting.new_from_json(invoice_handling_setting_attributes)
        end
      end
    end
  end
end
