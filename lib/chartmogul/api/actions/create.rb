# frozen_string_literal: true

module ChartMogul
  module API
    module Actions
      module Create
        def self.included(base)
          base.extend ClassMethods
        end

        def create!
          resp = handling_errors do
            connection.post(resource_path.apply(instance_attributes)) do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.dump(serialize_for_write)
            end
          end
          json = ChartMogul::Utils::JSONParser.parse(resp.body, skip_case_conversion: self.class.skip_case_conversion)

          assign_all_attributes(json)
        end

        module ClassMethods
          def create!(attributes = {})
            resource = new(attributes)

            resp = handling_errors do
              connection.post(resource_path.apply(attributes)) do |req|
                req.headers['Content-Type'] = 'application/json'
                req.body = JSON.dump(resource.serialize_for_write)
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
