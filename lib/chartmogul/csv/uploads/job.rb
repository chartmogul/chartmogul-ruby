# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Job < ChartMogul::Object
        writeable_attr :id
        writeable_attr :original_name
        writeable_attr :data_type
        writeable_attr :storage_path
        writeable_attr :percent_complete
        writeable_attr :created_at
        writeable_attr :updated_at
        writeable_attr :batch_name
      end
    end
  end
end
