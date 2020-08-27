# frozen_string_literal: true

module ChartMogul
  module CSV
    class Invoice < ChartMogul::Object
      include CSVObject
      extend CSVHeader

      FIELDS = %i[customer_external_id external_id date due_date currency].freeze
      HEADERS = %w[Customer\ external\ ID Invoice\ external\ ID Invoiced\ date Due\ date Currency].freeze
      CSVRow = Struct.new(*FIELDS)


      writeable_attr :date, type: :time
      writeable_attr :currency
      writeable_attr :external_id
      writeable_attr :customer_external_id
      writeable_attr :due_date, type: :time
    end
  end
end
