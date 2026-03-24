# frozen_string_literal: true

module ChartMogul
  module Concerns
    # Shared toggle_disabled! instance method for resources that support disabling.
    # Expects the including class to have a `uuid` attribute.
    module ToggleDisabled
      # Toggle the disabled state of the resource
      # @param disabled [Boolean] Whether to disable the resource
      # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
      # @return [self] the updated resource
      def toggle_disabled!(disabled:, handle_as_user_edit: nil)
        path = "#{resource_path.path}/#{uuid}/disabled_state"
        path = self.class.build_query_path(path, handle_as_user_edit: handle_as_user_edit)
        resp = handling_errors do
          self.class.json_patch(path, { disabled: disabled })
        end
        json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: self.class.immutable_keys)
        assign_all_attributes(json)
        self
      end
    end
  end
end
