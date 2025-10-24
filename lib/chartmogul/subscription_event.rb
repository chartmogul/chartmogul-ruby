# frozen_string_literal: true

module ChartMogul
  class SubscriptionEvent < APIResource
    set_resource_name 'SubscriptionEvent'
    set_resource_path '/data_platform/v1/subscription_events'

    readonly_attr :id
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
      custom_with_query_params!(:post, subscription_event: instance_attributes)
    end

    # This endpoint requires we send the attributes as:
    # { subscription_event: { key: value }}
    # So we do not include the API::Actions::Create module here and rather use a
    # variation of the method there to accommodate this difference in behaviour.
    def self.create!(attributes)
      custom_with_query_params!(:post, subscription_event: attributes)
    end

    def update!(attrs)
      custom_with_query_params!(:patch, subscription_event: attrs.merge(id: instance_attributes[:id]))
    end

    def destroy!
      # For destroy, we need to handle it differently since it doesn't use custom!
      attrs, query_params = extract_query_params(instance_attributes)
      path = query_params.empty? ? resource_path.path : resource_path.apply_with_get_params(query_params)
      
      handling_errors do
        connection.delete(path, subscription_event: { id: attrs[:id] })
      end
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
