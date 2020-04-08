# frozen_string_literal: true

module ChartMogul
  module Concerns
    module Summary
      def self.included(base)
        base.send :prepend, InstanceMethods

        base.instance_eval do
          readonly_attr :summary
        end
      end

      module InstanceMethods
        def set_summary(summary_attributes)
          @summary = ChartMogul::Summary.new_from_json(summary_attributes)
        end
      end
    end
  end
end
