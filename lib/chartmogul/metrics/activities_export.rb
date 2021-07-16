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

      def serialize_for_write
        super.tap do |attributes|
          attributes.clone.each do |k, v|
            attributes[preprocess_attributes(k)] = attributes.delete(k)
          end
        end
      end

      def preprocess_attributes(attribute)
        return attribute unless %i[start_date end_date].include?(attribute)

        attribute.to_s.tr('_', '-')
      end
    end
  end
end
