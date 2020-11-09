# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Invoice < Base
        set_resource_path 'v1/data_sources/:data_source_uuid/uploads'
        set_resource_name 'Invoice'

        def type
          @type = 'invoice'
        end
      end
    end
  end
end
