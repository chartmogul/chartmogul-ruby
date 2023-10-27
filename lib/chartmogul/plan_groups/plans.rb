# frozen_string_literal: true

module ChartMogul
  module PlanGroups
    class Plans < APIResource
      set_resource_name 'Plans'
      set_resource_path '/v1/plan_groups/:plan_group_uuid/plans'

      set_resource_root_key :plans

      include Concerns::Entries
      include Concerns::Pageable2
      include Concerns::PageableWithCursor
      include API::Actions::Custom

      set_entry_class Plan

      def self.all(plan_group_uuid, options = {})
        super(options.merge(plan_group_uuid: plan_group_uuid))
      end

      def next(plan_group_uuid, options = {})
        path = ChartMogul::ResourcePath.new("/v1/plan_groups/#{plan_group_uuid}/plans")
        custom!(:get, path.apply_with_get_params(options.merge(cursor: cursor)))
      end
    end
  end
end
