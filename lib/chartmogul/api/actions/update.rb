# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module Update
        def self.included(base)
          base.extend ClassMethods
        end

        def update!
          resp = handling_errors do
            connection.patch("#{resource_path.apply(instance_attributes)}/#{uuid}") do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.dump(serialize_for_write)
            end
          end
          json = ChartMogul::Utils::JSONParser.parse(resp.body)

          assign_all_attributes(json)
        end

        module ClassMethods
          def update!(uuid, attributes = {})
            resource = new(attributes)

            resp = handling_errors do
              connection.patch("#{resource_path.apply(attributes)}/#{uuid}") do |req|
                req.headers['Content-Type'] = 'application/json'
                req.body = JSON.dump(resource.serialize_for_write)
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
