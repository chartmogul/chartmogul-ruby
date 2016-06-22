module ChartMogul
  module Import
    class DataSource < APIResource
      set_resource_name 'Data Source'
      set_resource_path '/v1/import/data_sources'
      set_resource_root_key :data_sources

      writeable_attr :name
      readonly_attr :uuid
      readonly_attr :status
      readonly_attr :created_at, type: :time

      include API::Actions::All
      include API::Actions::Create
      include API::Actions::Destroy
    end
  end
end
