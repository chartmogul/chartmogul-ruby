# frozen_string_literal: true

module ChartMogul
  module CSV
    module CSVObject
      def to_csv
        data = fields.map { |e| send(e) }
        self.class::CSVRow.new(*data)
      end

      private

      def fields
        self.class::FIELDS
      end
    end
  end
end
