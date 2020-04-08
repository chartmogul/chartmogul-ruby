# frozen_string_literal: true

module ChartMogul
  module PlanGroups
    class Plans < APIResource
      set_resource_name 'Plans'
      set_resource_path '/v1/plan_groups/:plan_group_uuid/plans'

      set_resource_root_key :plans

      include Concerns::Entries
      include Concerns::Pageable2

      set_entry_class Plan
    end
  end
end
