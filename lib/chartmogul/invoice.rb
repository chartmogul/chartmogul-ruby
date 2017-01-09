module ChartMogul
  class Invoice < ChartMogul::Object
    readonly_attr :uuid

    writeable_attr :date, type: :time
    writeable_attr :currency
    writeable_attr :line_items, default: []
    writeable_attr :transactions, default: []
    writeable_attr :external_id
    writeable_attr :due_date, type: :time

    def serialize_line_items
      line_items.map(&:serialize_for_write)
    end

    def serialize_transactions
      transactions.map(&:serialize_for_write)
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
      when 'subscription' then ChartMogul::Import::LineItems::Subscription
      when 'one_time' then ChartMogul::Import::LineItems::OneTime
      end
    end

    def transaction_class(type)
      case type
      when 'payment' then ChartMogul::Import::Transactions::Payment
      when 'refund' then ChartMogul::Import::Transactions::Refund
      end
    end
  end
end
