# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class Note < APIResource
    set_resource_name 'CustomerNote'
    set_resource_path '/v1/customer_notes'

    readonly_attr :uuid

    writeable_attr :customer_uuid
    writeable_attr :type
    writeable_attr :text
    writeable_attr :author
    writeable_attr :text
    writeable_attr :call_duration
    writeable_attr :created_at
    writeable_attr :updated_at

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      Notes.all(options)
    end
  end

  class Notes < APIResource
    set_resource_name 'CustomerNotes'
    set_resource_path '/v1/customer_notes'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Note
  end
end
