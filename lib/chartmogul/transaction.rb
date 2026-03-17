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

    # Toggle the disabled state of a transaction
    # @param disabled [Boolean] Whether to disable the transaction
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def toggle_disabled!(disabled:, handle_as_user_edit: nil)
      path = "#{resource_path.path}/#{uuid}/disabled_state"
      path += "?handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ disabled: })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: self.class.immutable_keys)
      assign_all_attributes(json)
      self
    end

    # Retrieve a transaction by data_source_uuid and external_id
    def self.retrieve_by_external_id(data_source_uuid:, external_id:)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      resp = handling_errors do
        connection.get(path)
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Update a transaction by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.update_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil, **attributes)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      path += "&handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(attributes)
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Delete a transaction by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.destroy_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      path += "&handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      handling_errors do
        connection.delete(path)
      end
      true
    end

    # Toggle disabled state of a transaction by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.toggle_disabled_by_external_id!(data_source_uuid:, external_id:, disabled:, handle_as_user_edit: nil)
      path = "#{resource_path.path}/disabled_state?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      path += "&handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
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
