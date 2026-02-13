# frozen_string_literal: true

module ChartMogul
  class Invoice < APIResource
    set_resource_name 'Invoice'
    set_resource_path '/v1/invoices'

    readonly_attr :uuid
    readonly_attr :customer_uuid
    readonly_attr :disabled
    readonly_attr :disabled_at
    readonly_attr :disabled_by
    readonly_attr :edit_history_summary
    readonly_attr :errors

    writeable_attr :date, type: :time
    writeable_attr :currency
    writeable_attr :line_items, default: []
    writeable_attr :transactions, default: []
    writeable_attr :external_id
    writeable_attr :data_source_uuid
    writeable_attr :customer_external_id
    writeable_attr :due_date, type: :time

    include API::Actions::Retrieve
    include API::Actions::Update
    include API::Actions::Destroy

    # Toggle the disabled state of an invoice
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

    # Update the status of an invoice by external_id
    def self.update_status!(data_source_uuid:, invoice_external_id:, status:)
      path = "/v1/data_sources/#{data_source_uuid}/invoices/#{invoice_external_id}/status"
      handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ status: })
        end
      end
      true
    end

    # Update an invoice by data_source_uuid and external_id
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

    # Delete an invoice by data_source_uuid and external_id
    def self.destroy_by_external_id!(data_source_uuid:, external_id:)
      path = "#{resource_path.path}?data_source_uuid=#{data_source_uuid}&external_id=#{external_id}"
      handling_errors do
        connection.delete(path)
      end
      true
    end

    # Toggle disabled state of an invoice by data_source_uuid and external_id
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

    def serialize_line_items
      line_items.map(&:serialize_for_write)
    end

    def serialize_transactions
      transactions.map(&:serialize_for_write)
    end

    def self.all(options = {})
      Invoices.all(options)
    end

    private

    def set_line_items(line_items_attributes)
      @line_items = line_items_attributes.map.with_index do |line_item_attributes, index|
        existing_line_item = line_items[index]

        if existing_line_item
          existing_line_item.assign_all_attributes(line_item_attributes)
        else
          line_item_class(line_item_attributes[:type])
            .new_from_json(line_item_attributes.merge(invoice_uuid: uuid))
        end
      end
    end

    def set_transactions(transactions_attributes)
      @transactions = transactions_attributes.map.with_index do |transaction_attributes, index|
        existing_transaction = transactions[index]

        if existing_transaction
          existing_transaction.assign_all_attributes(transaction_attributes)
        else
          transaction_class(transaction_attributes[:type])
            .new_from_json(transaction_attributes.merge(invoice_uuid: uuid))
        end
      end
    end

    def line_item_class(type)
      case type
      when 'subscription' then ChartMogul::LineItems::Subscription
      when 'one_time' then ChartMogul::LineItems::OneTime
      end
    end

    def transaction_class(type)
      case type
      when 'payment' then ChartMogul::Transactions::Payment
      when 'refund' then ChartMogul::Transactions::Refund
      end
    end
  end

  class Invoices < APIResource
    set_resource_name 'Invoices'
    set_resource_path '/v1/invoices'

    set_resource_root_key :invoices

    include Concerns::Entries
    include Concerns::Pageable2
    include Concerns::PageableWithCursor

    set_entry_class Invoice
  end
end
