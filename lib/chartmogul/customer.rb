module ChartMogul
  class Customer < APIResource
    set_resource_name 'Customer'
    set_resource_path '/v1/customers'

    readonly_attr :uuid

    writeable_attr :external_id
    writeable_attr :name
    writeable_attr :email
    writeable_attr :company
    writeable_attr :country
    writeable_attr :state
    writeable_attr :city
    writeable_attr :zip
    writeable_attr :data_source_uuid
    writeable_attr :lead_created_at, type: :time
    writeable_attr :free_trial_started_at, type: :time

    include API::Actions::Create
    include API::Actions::Destroy

    def self.all(options = {})
      Customers.all(options)
    end

    def self.search(email)
      Customers.search(email)
    end

    def self.find_by_external_id(external_id)
      all(external_id: external_id).first
    end

    def subscriptions(options = {})
      @subscriptions ||= ChartMogul::Subscription.all(uuid, options)
    end

    def invoices(options = {})
      @invoices ||= ChartMogul::CustomerInvoices.all(uuid, options)
    end

    def invoices=(invoices_array)
      @invoices = ChartMogul::CustomerInvoices.new(customer_uuid: uuid, invoices: invoices_array)
    end


    class Customers < APIResource
      set_resource_name 'Customers'
      set_resource_path '/v1/customers'

      include Concerns::Entries
      include API::Actions::Custom
      include Concerns::Pageable
      include Concerns::Pageable2

      set_entry_class Customer

      def self.search(email)
        path = ChartMogul::ResourcePath.new('/v1/customers/search')
        custom!(:get, path.apply_with_get_params(email: email))
      end
    end
  end
end
