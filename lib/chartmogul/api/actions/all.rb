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
            json = JSON.parse(resp.body, symbolize_names: true)

            if resource_root_key
              json[resource_root_key].map { |attributes| new_from_json(attributes) }
            else
              new_from_json(json)
            end
          end
        end
      end
    end
  end
end
