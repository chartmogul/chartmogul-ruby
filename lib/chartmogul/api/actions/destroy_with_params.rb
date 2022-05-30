# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module DestroyWithParams
        def self.included(base)
          base.extend ClassMethods
        end

        def destroy_with_params!
          handling_errors do
            connection.delete(resource_path.path, instance_attributes)
          end
          true
        end

        module ClassMethods
          def destroy_with_params!(options = {})
            handling_errors do
              connection.delete(resource_path.path, options)
            end
            true
          end
        end
      end
    end
  end
end
