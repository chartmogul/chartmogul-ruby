# frozen_string_literal: true

module ChartMogul
  class Contact < APIResource
    set_resource_name 'Contact'
    set_resource_path '/v1/contacts'
    set_immutable_keys(%i[custom overrides historical_values])

    readonly_attr :uuid
    readonly_attr :historical_values

    writeable_attr :customer_uuid
    writeable_attr :data_source_uuid
    writeable_attr :customer_external_id
    writeable_attr :position
    writeable_attr :first_name
    writeable_attr :last_name
    writeable_attr :title
    writeable_attr :email
    writeable_attr :phone
    writeable_attr :linked_in
    writeable_attr :twitter
    writeable_attr :notes
    writeable_attr :external_id
    writeable_attr :custom
    writeable_attr :overrides

    include API::Actions::Create
    include API::Actions::Custom
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      Contacts.all(options)
    end

    def self.merge!(into_uuid:, from_uuid:)
      custom!(:post, "/v1/contacts/#{into_uuid}/merge/#{from_uuid}")
      true
    end

    def serialize_for_write
      super.tap do |attributes|
        attributes.clone.each do |attribute_name, attribute_value|
          if attribute_name == :custom && attribute_value.is_a?(Hash)
            payload = attribute_value.each_with_object([]) do |custom_value, arr|
              key, value = custom_value
              arr << ({ key:, value: })
            end
            attributes[:custom] = payload
          else
            attributes[attribute_name] = attribute_value
          end
        end
        # Include external_id attribute even when nil so callers can explicitly clear it
        attributes[:external_id] = nil if instance_variable_defined?(:@external_id) && external_id.nil?
      end
    end

    # Responses echo the current override state, so only overrides assigned by
    # the caller are serialized: replaying an echoed `true` flag on a later
    # update! would re-pin stale in-memory values on the server.
    def overrides=(value)
      @overrides_requested = true
      @overrides = value
    end

    def serialize_overrides
      overrides if @overrides_requested
    end

    private

    def set_overrides(value)
      @overrides_requested = false
      @overrides = value
    end
  end

  class Contacts < APIResource
    set_resource_name 'Contacts'
    set_resource_path '/v1/contacts'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Contact
  end
end
