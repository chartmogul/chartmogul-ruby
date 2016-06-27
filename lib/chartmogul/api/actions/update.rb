module ChartMogul
  module API
    module Actions
      module Update
        def update!
          resp = handling_errors do
            connection.patch("#{resource_path.apply(self.instance_attributes)}/#{uuid}") do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.dump(self.serialize_for_write)
            end
          end
          json = ChartMogul::Utils::JSONParser.parse(resp.body)

          self.assign_all_attributes(json)
        end
      end
    end
  end
end
