module ChartMogul
  module Import
    class DataSource < APIResource
      NAME = 'Data Source'
      RESOURCE_PATH = '/v1/import/data_sources'
      ROOT_KEY = :data_sources

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
