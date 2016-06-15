module ChartMogul
  module API
    module Actions
      module Destroy
        def destroy!
          handling_errors do
            connection.delete("#{self.class::RESOURCE_PATH}/#{uuid}")
          end
          true
        end
      end
    end
  end
end
