# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class CustomerInvoices < APIResource
    extend Forwardable
    include Enumerable

    set_resource_name 'Invoices'
    set_resource_path '/v1/import/customers/:customer_uuid/invoices'

    writeable_attr :invoices, default: []
    writeable_attr :customer_uuid
    writeable_query_param :handle_as_user_edit

    include API::Actions::All
    include API::Actions::Custom
    include Concerns::Pageable2
    include Concerns::PageableWithCursor

    def serialize_invoices
      map(&:serialize_for_write)
    end

    def create!
      # Merge serialized body with instance attributes for path/query parameter extraction
      body_data = serialize_for_write.merge(instance_attributes)
      custom_with_query_params!(:post, body_data)
    end

    def self.create!(attributes = {})
      resource = new(attributes)
      # Merge serialized body with original attributes for path/query parameter extraction  
      body_data = resource.serialize_for_write.merge(attributes)
      resource.custom_with_query_params!(:post, body_data)
    end

    def self.all(customer_uuid, options = {})
      super(options.merge(customer_uuid: customer_uuid))
    end

    def next(options = {})
      CustomerInvoices.all(customer_uuid, options.merge(cursor: cursor))
    end

    def self.destroy_all!(data_source_uuid, customer_uuid)
      path = ChartMogul::ResourcePath.new('v1/data_sources/:data_source_uuid/customers/:customer_uuid/invoices')
      handling_errors do
        connection.delete(path.apply(data_source_uuid: data_source_uuid, customer_uuid: customer_uuid))
      end
      true
    end

    def_delegators :invoices, :each, :[], :<<, :size, :length, :empty?, :first

    private

    # TODO: replace with Entries concern?
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
