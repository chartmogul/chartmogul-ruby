# frozen_string_literal: true

module ChartMogul
  module LineItems
    class OneTime < ChartMogul::Object
      readonly_attr :uuid

      writeable_attr :type, default: 'one_time'
      writeable_attr :amount_in_cents
      writeable_attr :description
      writeable_attr :quantity
      writeable_attr :discount_amount_in_cents
      writeable_attr :discount_code
      writeable_attr :tax_amount_in_cents
      writeable_attr :transaction_fees_in_cents
      writeable_attr :external_id
      writeable_attr :plan_uuid

      writeable_attr :invoice_uuid

      def initialize(attributes = {})
        super(attributes)
        @type = 'one_time'
      end
    end
  end
end
