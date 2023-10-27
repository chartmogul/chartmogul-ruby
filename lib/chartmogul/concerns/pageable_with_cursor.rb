# frozen_string_literal: true

module ChartMogul
  module Concerns
    module PageableWithCursor
      def self.included(base)
        base.instance_eval do
          readonly_attr :has_more
          readonly_attr :cursor
        end
      end

      def next(options = {})
        self.class.all(options.merge(cursor: cursor))
      end
    end
  end
end
