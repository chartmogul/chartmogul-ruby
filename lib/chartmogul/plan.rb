module ChartMogul
  class Plan < APIResource
    set_resource_name 'Plan'
    set_resource_path '/v1/plans'

    readonly_attr :uuid

    writeable_attr :name
    writeable_attr :interval_count
    writeable_attr :interval_unit
    writeable_attr :external_id

    writeable_attr :data_source_uuid

    include API::Actions::Create
    include API::Actions::Update
    include API::Actions::Destroy
    include API::Actions::Custom

    def self.retrieve(uuid)
      custom!(:get, "/v1/plans/#{uuid}")
    end

    def self.all(options = {})
      Plans.all(options)
    end
  end
  

  class Plans < APIResource
    set_resource_name 'Plans'
    set_resource_path '/v1/plans'

    set_resource_root_key :plans

    include Concerns::Entries
    include Concerns::Pageable2

    set_entry_class Plan
  end
end
