# frozen_string_literal: true

module ChartMogul
  module CSV
    module CSVHeader
      def csv_file_headers
        Struct.new(*fields).new(*headers)
      end

      private

      def headers
        self::HEADERS
      end

      def fields
        self::FIELDS
      end
    end
  end
end
