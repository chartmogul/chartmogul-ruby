# frozen_string_literal: true

module ChartMogul
  module Concerns
    # Shared class methods for resources that support CRUD by data_source_uuid + external_id.
    # These resources use query-parameter-based lookups (not path-based).
    module ExternalIdOperations
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Retrieve a resource by data_source_uuid and external_id
        def retrieve_by_external_id(data_source_uuid:, external_id:)
          path = build_query_path(
            resource_path.path,
            data_source_uuid: data_source_uuid,
            external_id: external_id
          )
          resp = handling_errors { connection.get(path) }
          json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: immutable_keys)
          new_from_json(json)
        end

        # Update a resource by data_source_uuid and external_id
        # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
        def update_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil, **attributes)
          path = build_query_path(
            resource_path.path,
            data_source_uuid: data_source_uuid,
            external_id: external_id,
            handle_as_user_edit: handle_as_user_edit
          )
          resp = handling_errors { json_patch(path, attributes) }
          json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: immutable_keys)
          new_from_json(json)
        end

        # Delete a resource by data_source_uuid and external_id
        # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
        def destroy_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil)
          path = build_query_path(
            resource_path.path,
            data_source_uuid: data_source_uuid,
            external_id: external_id,
            handle_as_user_edit: handle_as_user_edit
          )
          handling_errors { connection.delete(path) }
          true
        end

        # Toggle disabled state of a resource by data_source_uuid and external_id
        # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
        def toggle_disabled_by_external_id!(data_source_uuid:, external_id:, disabled:, handle_as_user_edit: nil)
          path = build_query_path(
            "#{resource_path.path}/disabled_state",
            data_source_uuid: data_source_uuid,
            external_id: external_id,
            handle_as_user_edit: handle_as_user_edit
          )
          resp = handling_errors { json_patch(path, { disabled: disabled }) }
          json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: immutable_keys)
          new_from_json(json)
        end
      end
    end
  end
end
