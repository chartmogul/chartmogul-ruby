# frozen_string_literal: true

module ChartMogul
  module CSV
    module CSVHeader
      def csv_file_headers
        new(Hash[fields.zip(headers)])
      end
    end
  end
end
