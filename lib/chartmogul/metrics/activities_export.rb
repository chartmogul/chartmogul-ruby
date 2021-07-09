# frozen_string_literal: true

module ChartMogul
  module Metrics
    class ActivitiesExport < APIResource
      set_resource_name 'ActivitiesExport'
      set_resource_path '/v1/activities_export'

      readonly_attr :id
      readonly_attr :status
      readonly_attr :file_url
      readonly_attr :params
      readonly_attr :expires_at
      readonly_attr :created_at

      writeable_attr :start_date
      writeable_attr :end_date
      writeable_attr :type

      include API::Actions::Retrieve
      include API::Actions::Create

      def reload
        self.class.retrieve(id)
      end
    end
  end
end
