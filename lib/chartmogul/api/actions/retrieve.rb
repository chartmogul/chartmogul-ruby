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
            resp = handling_errors do
              connection.get("#{resource_path.apply(options)}/#{uuid}") do |req|
                req.headers['Content-Type'] = 'application/json'
              end
            end
            json = ChartMogul::Utils::JSONParser.parse(resp.body, skip_case_conversion: skip_case_conversion)
            new_from_json(json)
          end
        end
      end
    end
  end
end
