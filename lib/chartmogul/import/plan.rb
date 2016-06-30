module ChartMogul
  module Import
    class Plan < APIResource
      set_resource_name 'Plan'
      set_resource_path '/v1/import/plans'
      set_resource_root_key :plans

      readonly_attr :uuid

      writeable_attr :name
      writeable_attr :interval_count
      writeable_attr :interval_unit
      writeable_attr :external_id

      writeable_attr :data_source_uuid

      include API::Actions::All
      include API::Actions::Create
    end
  end
end
