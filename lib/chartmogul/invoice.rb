# frozen_string_literal: true

module ChartMogul
  class Invoice < APIResource
    set_resource_name 'Invoice'
    set_resource_path '/v1/invoices'

    readonly_attr :uuid
    readonly_attr :customer_uuid

    writeable_attr :date, type: :time
    writeable_attr :currency
    writeable_attr :line_items, default: []
    writeable_attr :transactions, default: []
    writeable_attr :external_id
    writeable_attr :data_source_uuid
    writeable_attr :customer_external_id
    writeable_attr :due_date, type: :time

    include API::Actions::Retrieve
    include API::Actions::Destroy

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
    include Concerns::PageableWithCursor

    set_entry_class Invoice
  end
end
