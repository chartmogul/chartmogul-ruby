module ChartMogul
  module Concerns
    module Pageable2
      def self.included(base)
        base.instance_eval do
          readonly_attr :current_page
          readonly_attr :total_pages
        end
      end
    end
  end
end
