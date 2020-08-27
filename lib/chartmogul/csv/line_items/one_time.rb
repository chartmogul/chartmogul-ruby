# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      OneTime = Struct.new(*ChartMogul::CSV::LineItems::SUBSCRIPTION_FIELDS) do
        include BaseStruct
        extend CSVHeader

        def type
          'one_time'
        end

        def self.headers
          SUBSCRIPTION_HEADERS
        end

        def self.fields
          SUBSCRIPTION_FIELDS
        end
      end
    end
  end
end
