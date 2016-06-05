module ChartMogul
  module API
    module Actions
      module Create
        def self.included(base)
          base.extend ClassMethods
        end

        def create!(attrs = {})
          resource = self.class.new(attrs)

          resp = handling_errors do
            connection.post(self.class::RESOURCE_PATH) do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.dump(resource.serialize_for_write)
            end
          end

          json = JSON.parse(resp.body, symbolize_names: true)
          self.class.new_from_json(json)
        end

        module ClassMethods
          def create!(attrs = {})
            resource = new(attrs)

            resp = handling_errors do
                connection.post(self::RESOURCE_PATH) do |req|
                req.headers['Content-Type'] = 'application/json'
                req.body = JSON.dump(resource.serialize_for_write)
              end
            end

            json = JSON.parse(resp.body, symbolize_names: true)
            new_from_json(json)
          end
        end
      end
    end
  end
end
