# frozen_string_literal: true

module ChartMogul
  # Standalone LineItem resource for CRUD operations on existing line items.
  # Note: For creating line items on invoices, use LineItems::Subscription or LineItems::OneTime.
  class LineItem < APIResource
    set_resource_name 'LineItem'
    set_resource_path '/v1/line_items'

    readonly_attr :uuid
    readonly_attr :disabled
    readonly_attr :disabled_at
    readonly_attr :disabled_by
    readonly_attr :invoice_uuid
    readonly_attr :subscription_uuid
    readonly_attr :edit_history_summary

    writeable_attr :type
    writeable_attr :subscription_external_id
    writeable_attr :subscription_set_external_id
    writeable_attr :plan_uuid
    writeable_attr :service_period_start, type: :time
    writeable_attr :service_period_end, type: :time
    writeable_attr :amount_in_cents
    writeable_attr :quantity
    writeable_attr :discount_amount_in_cents
    writeable_attr :discount_code
    writeable_attr :discount_description
    writeable_attr :tax_amount_in_cents
    writeable_attr :transaction_fees_in_cents
    writeable_attr :transaction_fees_currency
    writeable_attr :external_id
    writeable_attr :data_source_uuid
    writeable_attr :prorated
    writeable_attr :proration_type
    writeable_attr :cancelled_at, type: :time
    writeable_attr :description
    writeable_attr :account_code
    writeable_attr :event_order

    include API::Actions::Retrieve
    include API::Actions::Update
    include API::Actions::Destroy

    # Toggle the disabled state of a line item
    def toggle_disabled!(disabled:)
      resp = handling_errors do
        connection.patch("#{resource_path.path}/#{uuid}/disabled_state") do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ disabled: })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: self.class.immutable_keys)
      assign_all_attributes(json)
      self
    end

    # Create a line item for an invoice
    def self.create!(invoice_uuid:, **attributes)
      path = "/v1/import/invoices/#{invoice_uuid}/line_items"
      resp = handling_errors do
        connection.post(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(attributes)
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Retrieve a line item by data_source_uuid and external_id
    def self.retrieve_by_external_id(data_source_uuid:, external_id:)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      resp = handling_errors do
        connection.get(path)
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Update a line item by data_source_uuid and external_id
    def self.update_by_external_id!(data_source_uuid:, external_id:, **attributes)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(attributes)
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Delete a line item by data_source_uuid and external_id
    def self.destroy_by_external_id!(data_source_uuid:, external_id:)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      handling_errors do
        connection.delete(path)
      end
      true
    end

    # Toggle disabled state of a line item by data_source_uuid and external_id
    def self.toggle_disabled_by_external_id!(data_source_uuid:, external_id:, disabled:)
      path = "#{resource_path.path}/disabled_state?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ disabled: })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end
  end
end
