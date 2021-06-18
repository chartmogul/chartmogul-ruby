# frozen_string_literal: true

module ChartMogul
  module Concerns
    module PageableWithAnchor
      def self.included(base)
        base.instance_eval do
          readonly_attr :has_more
          readonly_attr :per_page
        end
      end
    end
  end
end
