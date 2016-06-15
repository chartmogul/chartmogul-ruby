module ChartMogul
  module API
    module Actions
      module All
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def all
            resp = handling_errors do
              connection.get(self::RESOURCE_PATH)
            end
            json = JSON.parse(resp.body, symbolize_names: true)
            json[self::ROOT_KEY].map do |data_source_attrs|
              self.new_from_json(data_source_attrs)
            end
          end
        end
      end
    end
  end
end
