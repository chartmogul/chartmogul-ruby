# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module Retrieve
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def retrieve(uuid, options = {})
            path = "#{resource_path.apply(options)}/#{uuid}"
            path_param_keys = resource_path.named_params.values
            query_params = options.reject { |key| path_param_keys.include?(key) }
            resp = handling_errors do
              connection.get(path) do |req|
                req.headers['Content-Type'] = 'application/json'
                req.params = query_params
              end
            end
            json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: immutable_keys)
            new_from_json(json)
          end
        end
      end
    end
  end
end
