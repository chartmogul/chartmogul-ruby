module ChartMogul
  module API
    module Actions
      module Custom
        def self.included(base)
          base.extend ClassMethods
        end

        def custom_without_assign!(http_method, http_path, body_data = {})
          self.class.custom_without_assign!(http_method, http_path, body_data)
        end

        def custom!(http_method, http_path, body_data = {})
          json = custom_without_assign!(http_method, http_path, body_data)
          assign_all_attributes(json)
        end

        module ClassMethods
          def custom_without_assign!(http_method, http_path, body_data = {})
            resp = handling_errors do
              connection.send(http_method, http_path) do |req|
                req.headers['Content-Type'] = 'application/json'
                req.body = JSON.dump(body_data)
              end
            end
            ChartMogul::Utils::JSONParser.parse(resp.body)
          end

          def custom!(http_method, http_path, body_data = {})
            json = custom_without_assign!(http_method, http_path, body_data = {})

            if resource_root_key && json.key?(resource_root_key)
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
