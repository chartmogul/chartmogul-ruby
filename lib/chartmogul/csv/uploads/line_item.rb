# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class LineItem < Base
        set_resource_path 'v1/data_sources/:data_source_uuid/uploads'
        set_resource_name 'LineItem'

        def type
          @type = 'line_item'
        end
      end
    end
  end
end
