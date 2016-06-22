module ChartMogul
  module Import
    class Customer < APIResource
      set_resource_name 'Customer'
      set_resource_path '/v1/import/customers'
      set_resource_root_key :customers

      writeable_attr :data_source_uuid
      writeable_attr :external_id
      writeable_attr :name
      writeable_attr :email
      writeable_attr :company
      writeable_attr :country
      writeable_attr :state
      writeable_attr :city
      writeable_attr :zip

      readonly_attr :uuid

      include API::Actions::All
      include API::Actions::Create
      include API::Actions::Destroy

      def invoices
        @invoices ||= CustomerInvoices.all(customer_uuid: uuid)
      end

      def invoices=(invoices_array)
        @invoices = CustomerInvoices.new(customer_uuid: uuid, invoices: invoices_array)
      end
    end
  end
end
