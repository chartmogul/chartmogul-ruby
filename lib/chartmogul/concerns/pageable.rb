module ChartMogul
  module Concerns
    module Pageable
      def self.included(base)
        base.instance_eval do
          readonly_attr :has_more
          readonly_attr :per_page
          readonly_attr :page
        end
      end
    end
  end
end

