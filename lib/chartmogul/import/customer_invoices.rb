require 'forwardable'

module ChartMogul
  module Import
    class CustomerInvoices < APIResource
      extend Forwardable
      include Enumerable

      set_resource_name 'Invoices'
      set_resource_path '/v1/import/customers/:customer_uuid/invoices'

      writeable_attr :invoices, default: []

      writeable_attr :customer_uuid

      include API::Actions::All
      include API::Actions::Create

      def serialize_invoices
        map(&:serialize_for_write)
      end

      def_delegators :invoices, :each, :[], :<<, :size, :length

      private

      def set_invoices(invoices_attributes)
        @invoices = invoices_attributes.map.with_index do |invoice_attributes, index|
          existing_invoice = invoices[index]

          if existing_invoice
            existing_invoice.assign_all_attributes(invoice_attributes)
          else
            Invoice.new_from_json(invoice_attributes)
          end
        end
      end
    end
  end
end
