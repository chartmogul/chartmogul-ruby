module ChartMogul
  module API
    module Actions
      module Custom
        def custom_request!(http_method, http_path, body_data = {})
          resp = handling_errors do
            connection.send(http_method, http_path) do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.dump(body_data)
            end
          end
          json = JSON.parse(resp.body, symbolize_names: true)

          self.assign_all_attributes(json)
        end
      end
    end
  end
end
