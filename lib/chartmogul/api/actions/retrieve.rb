# frozen_string_literal: true

require 'uri'

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
            path = "#{path}?#{URI.encode_www_form(query_params)}" if query_params.any?
            resp = handling_errors do
              connection.get(path) do |req|
                req.headers['Content-Type'] = 'application/json'
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
