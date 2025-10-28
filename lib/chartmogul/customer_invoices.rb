# frozen_string_literal: true

require "forwardable"

module ChartMogul
  class CustomerInvoices < APIResource
    extend Forwardable
    include Enumerable

    set_resource_name "Invoices"
    set_resource_path "/v1/import/customers/:customer_uuid/invoices"

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
      # Only merge writeable_query_params to avoid overwriting serialized data
      query_params_data = instance_attributes.select { |k, _| self.class.query_params.include?(k.to_sym) }
      body_data = serialize_for_write.merge(query_params_data)
      custom_with_query_params!(:post, body_data)
    end

    def self.create!(attributes = {})
      resource = new(attributes)
      # Only merge writeable_query_params to avoid overwriting serialized data
      query_params_data = attributes.select { |k, _| query_params.include?(k.to_sym) }
      body_data = resource.serialize_for_write.merge(query_params_data)
      resource.custom_with_query_params!(:post, body_data)
    end

    def update!(attrs = {})
      # Assign new attributes before serializing to ensure they are included
      assign_all_attributes(attrs)
      query_params_data = instance_attributes.select { |k, _| self.class.query_params.include?(k.to_sym) }
      body_data = serialize_for_write.merge(query_params_data)
      custom_with_query_params!(:put, body_data)
    end

    def self.all(customer_uuid, options = {})
      super(options.merge(customer_uuid: customer_uuid))
    end

    def next(options = {})
      CustomerInvoices.all(customer_uuid, options.merge(cursor: cursor))
    end

    def self.destroy_all!(data_source_uuid, customer_uuid)
      path = ChartMogul::ResourcePath.new("v1/data_sources/:data_source_uuid/customers/:customer_uuid/invoices")
      handling_errors do
        connection.delete(path.apply(data_source_uuid: data_source_uuid, customer_uuid: customer_uuid))
      end
      true
    end

    def_delegators :invoices, :each, :[], :<<, :size, :length, :empty?, :first

    private

    # TODO: replace with Entries concern?
    # NOTE: called in the assign_all_attributes method
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
