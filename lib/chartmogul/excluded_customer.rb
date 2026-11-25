# frozen_string_literal: true

module ChartMogul
  class ExcludedCustomer < APIResource
    set_resource_name 'ExcludedCustomer'
    set_resource_path '/v1/excluded_customers'

    readonly_attr :customer_uuid
    readonly_attr :data_source_uuid
    readonly_attr :external_id
    readonly_attr :name
    readonly_attr :email
    readonly_attr :excluded_at, type: :time
    readonly_attr :status

    include API::Actions::Custom

    def self.all(options = {})
      ExcludedCustomers.all(options)
    end

    # Removes the customer from the exclude list. The returned object's status
    # is 'reimporting' or 'manual_reimport_required'.
    def self.reinclude!(customer_uuid)
      custom!(:delete, "#{resource_path.path}/#{customer_uuid}")
    end

    def reinclude!
      custom!(:delete, "#{resource_path.path}/#{customer_uuid}")
    end
  end

  class ExcludedCustomers < APIResource
    set_resource_name 'ExcludedCustomers'
    set_resource_path '/v1/excluded_customers'

    include Concerns::Entries
    include Concerns::PageableWithCursor

    set_entry_class ExcludedCustomer
  end
end
