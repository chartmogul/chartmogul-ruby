module ChartMogul
  class PlanGroup < APIResource
    set_resource_name 'PlanGroup'
    set_resource_path '/v1/plan_groups'

    readonly_attr :uuid
    readonly_attr :plans_count

    writeable_attr :name
    writeable_attr :plans, default: []

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      PlanGroups.all(options)
    end

    def serialize_plans
      plans.map(&:uuid)
    end

    class PlanGroups < APIResource
      set_resource_name 'PlanGroups'
      set_resource_path '/v1/plan_groups'

      set_resource_root_key :plan_groups

      include Concerns::Entries
      include Concerns::Pageable2

      set_entry_class PlanGroup
    end
  end
end
