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
    readonly_attr :errors

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
    include Concerns::ToggleDisabled
    include Concerns::ExternalIdOperations

    # Create a line item for an invoice
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.create!(invoice_uuid:, handle_as_user_edit: nil, **attributes)
      path = build_query_path(
        "/v1/import/invoices/#{invoice_uuid}/line_items",
        handle_as_user_edit: handle_as_user_edit
      )
      resp = handling_errors { json_post(path, attributes) }
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end
  end
end
