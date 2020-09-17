# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Customer < Base
        set_resource_path 'v1/data_sources/:data_source_uuid/uploads'
        set_resource_name 'Customer'

        def type
          @type = 'customer'
        end
      end
    end
  end
end
