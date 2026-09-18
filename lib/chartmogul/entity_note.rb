# frozen_string_literal: true

module ChartMogul
  class EntityNote < APIResource
    set_resource_name 'EntityNote'
    set_resource_path '/v1/notes'

    readonly_attr :uuid
    readonly_attr :associated_object
    readonly_attr :associated_object_uuid
    readonly_attr :author

    writeable_attr :customer_uuid
    writeable_attr :associated_object_identifier
    writeable_attr :type
    writeable_attr :text
    writeable_attr :author_email
    writeable_attr :call_duration
    writeable_attr :created_at
    writeable_attr :updated_at

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      EntityNotes.all(options)
    end
  end

  class EntityNotes < APIResource
    set_resource_name 'EntityNotes'
    set_resource_path '/v1/notes'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class EntityNote
  end
end
