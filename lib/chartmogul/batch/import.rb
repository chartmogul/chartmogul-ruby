# frozen_string_literal: true

module ChartMogul
  module Batch
    class Import < APIResource
      include API::Actions::Create

      writeable_attr :invoices, default: []
      writeable_attr :customers, default: []
      writeable_attr :plans, default: []
      writeable_attr :transactions, default: []
      writeable_attr :line_items, default: []
      writeable_attr :cancellations, default: []
      writeable_attr :data_source_uuid

      set_resource_path '/v2/import/:data_source_uuid'

      def serialize_invoices
        invoices.map(&:serialize_for_write)
      end

      def serialize_plans
        plans.map(&:serialize_for_write)
      end

      def serialize_customers
        customers.map(&:serialize_for_write)
      end

      def serialize_cancellations
        cancellations.map(&:serialize_for_write)
      end

      def serialize_transactions
        transactions.map(&:serialize_for_write)
      end

      def serialize_line_items
        line_items.map(&:serialize_for_write)
      end
    end
  end
end
