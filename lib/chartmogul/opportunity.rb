# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class Opportunity < APIResource
    set_resource_name 'Opportunity'
    set_resource_path '/v1/opportunities'
    set_immutable_keys([:custom])

    readonly_attr :uuid
    readonly_attr :created_at
    readonly_attr :updated_at

    writeable_attr :customer_uuid
    writeable_attr :owner
    writeable_attr :pipeline
    writeable_attr :pipeline_stage
    writeable_attr :estimated_close_date
    writeable_attr :currency
    writeable_attr :amount_in_cents
    writeable_attr :type
    writeable_attr :forecast_category
    writeable_attr :win_likelihood
    writeable_attr :custom

    include API::Actions::Create
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      Opportnities.all(options)
    end
  end

  class Opportnities < APIResource
    set_resource_name 'Opportunities'
    set_resource_path '/v1/opportunities'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class Opportunity
  end
end
