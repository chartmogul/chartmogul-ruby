module ChartMogul
  class Ping < APIResource
    set_resource_name 'Ping'
    set_resource_path '/v1/ping'

    readonly_attr :data

    include API::Actions::Custom

    def self.ping
      custom!(:get, '/v1/ping')
    end
  end
end
