# frozen_string_literal: true

module ChartMogul
  class SubscriptionEvent < APIResource
    set_resource_name 'SubscriptionEvent'
    set_resource_path '/v1/subscription_events'

    readonly_attr :id
    readonly_attr :disabled
    readonly_attr :disabled_at
    writeable_attr :data_source_uuid
    writeable_attr :customer_external_id
    writeable_attr :subscription_set_external_id
    writeable_attr :subscription_external_id
    writeable_attr :plan_external_id
    writeable_attr :event_date
    writeable_attr :effective_date
    writeable_attr :event_type
    writeable_attr :external_id
    readonly_attr :errors
    readonly_attr :created_at
    readonly_attr :updated_at
    writeable_attr :quantity
    writeable_attr :currency
    writeable_attr :amount_in_cents
    writeable_attr :tax_amount_in_cents
    writeable_attr :retracted_event_id
    writeable_query_param :handle_as_user_edit

    include API::Actions::Custom
    include API::Actions::DestroyWithParams

    def self.all(options = {})
      SubscriptionEvents.all(options)
    end

    def create!
      custom_with_query_params!(:post, { subscription_event: instance_attributes }, :subscription_event)
    end

    # This endpoint requires we send the attributes as:
    # { subscription_event: { key: value }}
    # So we do not include the API::Actions::Create module here and rather use a
    # variation of the method there to accommodate this difference in behaviour.
    def self.create!(attributes)
      custom_with_query_params!(:post, { subscription_event: attributes }, :subscription_event)
    end

    def update!(attrs)
      custom_with_query_params!(:patch, { subscription_event: attrs.merge(id: instance_attributes[:id]) },
                                :subscription_event)
    end

    # Instance method: destroys this subscription event
    def destroy!
      handling_errors do
        connection.delete(resource_path.path, subscription_event: { id: instance_attributes[:id] })
      end
    end

    # Class method: accepts both flat and envelope-wrapped params for backwards compatibility
    #   SubscriptionEvent.destroy!(id: 123)                              # flat params
    #   SubscriptionEvent.destroy!(subscription_event: { id: 123 })     # envelope-wrapped
    def self.destroy!(params = {})
      body = params.key?(:subscription_event) ? params : { subscription_event: params }
      handling_errors do
        connection.delete(resource_path.path, body)
      end
      true
    end

    # Toggle the disabled state of a subscription event
    # @param disabled [Boolean] Whether to disable the subscription event
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def toggle_disabled!(disabled:, handle_as_user_edit: nil)
      path = "#{resource_path.path}/#{instance_attributes[:id]}/disabled_state"
      path += "?handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ disabled: })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys: self.class.immutable_keys)
      assign_all_attributes(json[:subscription_event] || json)
      self
    end

    # Update a subscription event by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.update_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil, **attributes)
      path = resource_path.path
      path += "?handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ subscription_event: attributes.merge(data_source_uuid:, external_id:) })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json[:subscription_event] || json)
    end

    # Delete a subscription event by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.destroy_by_external_id!(data_source_uuid:, external_id:, handle_as_user_edit: nil)
      path = resource_path.path
      path += "?handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      handling_errors do
        connection.delete(path, subscription_event: { data_source_uuid:, external_id: })
      end
      true
    end

    # Toggle disabled state of a subscription event by data_source_uuid and external_id
    # @param handle_as_user_edit [Boolean] If true, the change is treated as a user edit
    def self.toggle_disabled_by_external_id!(data_source_uuid:, external_id:, disabled:, handle_as_user_edit: nil)
      path = "#{resource_path.path}/disabled_state"
      path += "?handle_as_user_edit=#{handle_as_user_edit}" unless handle_as_user_edit.nil?
      resp = handling_errors do
        connection.patch(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({
                                 subscription_event: { data_source_uuid:, external_id: },
                                 disabled:
                               })
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json[:subscription_event] || json)
    end
  end

  class SubscriptionEvents < APIResource
    set_resource_name 'SubscriptionEvents'
    set_resource_path '/v1/subscription_events'

    set_resource_root_key :subscription_events

    writeable_attr :meta

    include API::Actions::All
    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class SubscriptionEvent
  end
end
