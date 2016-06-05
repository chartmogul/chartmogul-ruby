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

      include ChartMogul::API::Actions::All
      include ChartMogul::API::Actions::Create
      include ChartMogul::API::Actions::Destroy
    end
  end
end
