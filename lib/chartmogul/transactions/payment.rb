# frozen_string_literal: true

module ChartMogul
  module Transactions
    class Payment < APIResource
      set_resource_name 'Payment Transaction'
      set_resource_path '/v1/import/invoices/:invoice_uuid/transactions'

      readonly_attr :uuid

      writeable_attr :type, default: 'payment'
      writeable_attr :date, type: :time
      writeable_attr :result
      writeable_attr :external_id
      writeable_attr :amount_in_cents
      writeable_attr :invoice_uuid

      def initialize(attributes = {})
        super(attributes)
        @type = 'payment'
      end

      include API::Actions::Create
    end
  end
end
