# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Plan < Base
        set_resource_path 'data_platform/v1/data_sources/:data_source_uuid/uploads'
        set_resource_name 'Plan'

        def type
          @type = 'plan'
        end
      end
    end
  end
end
