# frozen_string_literal: true

module ChartMogul
  module Concerns
    module ProcessingStatus
      def self.included(base)
        base.send :prepend, InstanceMethods

        base.instance_eval do
          readonly_attr :processing_status
        end
      end

      module InstanceMethods
        def set_processing_status(processing_status_attributes)
          @processing_status = ChartMogul::DataSourceSettings::ProcessingStatus.new_from_json(processing_status_attributes) if processing_status_attributes
        end
      end
    end
  end
end
