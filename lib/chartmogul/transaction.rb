# frozen_string_literal: true

module ChartMogul
  # Standalone Transaction resource for CRUD operations on existing transactions.
  # Note: For creating transactions on invoices, use Transactions::Payment or Transactions::Refund.
  class Transaction < APIResource
    set_resource_name 'Transaction'
    set_resource_path '/v1/transactions'

    readonly_attr :uuid
    readonly_attr :disabled
    readonly_attr :disabled_at
    readonly_attr :disabled_by
    readonly_attr :invoice_uuid
    readonly_attr :edit_history_summary
    readonly_attr :errors

    writeable_attr :type
    writeable_attr :date, type: :time
    writeable_attr :result
    writeable_attr :external_id
    writeable_attr :data_source_uuid
    writeable_attr :amount_in_cents
    writeable_attr :transaction_fees_in_cents
    writeable_attr :transaction_fees_currency

    include API::Actions::Retrieve
    include API::Actions::Update
    include API::Actions::Destroy
    include Concerns::ToggleDisabled
    include Concerns::ExternalIdOperations
  end
end
