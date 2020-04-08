# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module Destroy
        def self.included(base)
          base.extend ClassMethods
        end

        def destroy!
          handling_errors do
            connection.delete("#{resource_path.apply(instance_attributes)}/#{uuid}")
          end
          true
        end

        module ClassMethods
          def destroy!(options = {})
            handling_errors do
              connection.delete("#{resource_path.apply(options)}/#{options[:uuid]}")
            end
            true
          end
        end
      end
    end
  end
end
