# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class CustomerNote < APIResource
    set_resource_name 'CustomerNote'
    set_resource_path '/v1/customers/:customer_uuid/notes'

    readonly_attr :customer_uuid
    readonly_attr :author

    writeable_attr :type
    writeable_attr :text
    writeable_attr :author_email
    writeable_attr :text
    writeable_attr :call_duration
    writeable_attr :created_at
    writeable_attr :updated_at

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update
    include API::Actions::Custom
  end

  class CustomerNotes < APIResource
    set_resource_name 'CustomerNotes'
    set_resource_path '/v1/customers/:customer_uuid/notes'

    readonly_attr :customer_uuid

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class CustomerNote
  end
end
