# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module All
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def all(options = {})
            resp = handling_errors do
              connection.get(resource_path.apply_with_get_params(options)) do |req|
                req.headers['Content-Type'] = 'application/json'
              end
            end
            json = ChartMogul::Utils::JSONParser.parse(resp.body)
            new_from_json(json)
          end
        end
      end
    end
  end
end
