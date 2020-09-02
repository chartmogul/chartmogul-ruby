# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Cancellation < Base
        set_resource_path 'data_platform/v1/data_sources/:data_source_uuid/uploads'
        set_resource_name 'Cancellation'

        def type
          @type = 'cancellation'
        end
      end
    end
  end
end
