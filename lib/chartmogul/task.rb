# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class Task < APIResource
    set_resource_name 'Task'
    set_resource_path '/v1/tasks'

    readonly_attr :task_uuid
    readonly_attr :created_at
    readonly_attr :updated_at

    writeable_attr :customer_uuid
    writeable_attr :task_details
    writeable_attr :assignee
    writeable_attr :due_date
    writeable_attr :completed_at

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      Tasks.all(options)
    end
  end

  class Tasks < APIResource
    set_resource_name 'Tasks'
    set_resource_path '/v1/tasks'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Task
  end
end
