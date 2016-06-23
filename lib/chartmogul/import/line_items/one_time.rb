module ChartMogul
  module Import
    module LineItems
      class OneTime < ChartMogul::Object
        writeable_attr :type, default: 'one_time'
        writeable_attr :amount_in_cents
        writeable_attr :description
        writeable_attr :quantity
        writeable_attr :discount_amount_in_cents
        writeable_attr :discount_code
        writeable_attr :tax_amount_in_cents
        writeable_attr :external_id

        readonly_attr :uuid
      end
    end
  end
end
