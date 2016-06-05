module ChartMogul
  module Import
    class Plan < APIResource
      NAME = 'Plan'
      RESOURCE_PATH = '/v1/import/plans'
      ROOT_KEY = :plans

      writeable_attr :data_source_uuid
      writeable_attr :name
      writeable_attr :interval_count
      writeable_attr :interval_unit
      writeable_attr :external_id

      readonly_attr :uuid

      include API::Actions::All
      include API::Actions::Create
    end
  end
end
