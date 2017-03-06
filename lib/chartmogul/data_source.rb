module ChartMogul
  class DataSource < APIResource
    set_resource_name 'Data Source'
    set_resource_path '/v1/data_sources'
    set_resource_root_key :data_sources

    readonly_attr :uuid
    readonly_attr :status
    readonly_attr :system
    readonly_attr :created_at, type: :time

    writeable_attr :name

    include API::Actions::All
    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Custom

    def self.retrieve(uuid)
      custom!(:get, "/v1/data_sources/#{uuid}")
    end
  end
end
