module ChartMogul
  module Import
    module Transactions
      class Payment < ChartMogul::Object
        writeable_attr :type, default: 'payment'
        writeable_attr :date, type: :time
        writeable_attr :result
        writeable_attr :external_id

        readonly_attr :uuid
      end
    end
  end
end
