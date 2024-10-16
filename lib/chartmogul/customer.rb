# frozen_string_literal: true

module ChartMogul
  # rubocop:disable Metrics/ClassLength
  class Customer < APIResource
    set_resource_name 'Customer'
    set_resource_path '/v1/customers'
    set_immutable_keys(%i[attributes custom])

    readonly_attr :uuid
    readonly_attr :id

    readonly_attr :status
    readonly_attr :customer_since, type: :time
    readonly_attr :address
    readonly_attr :mrr
    readonly_attr :arr
    readonly_attr :billing_system_url
    readonly_attr :chartmogul_url
    readonly_attr :billing_system_type
    readonly_attr :currency
    readonly_attr :currency_sign
    readonly_attr :data_source_uuids
    readonly_attr :external_ids

    writeable_attr :attributes
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
    writeable_attr :owner
    writeable_attr :primary_contact
    writeable_attr :website_url

    include API::Actions::Create
    include API::Actions::Custom
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include API::Actions::Update

    def self.all(options = {})
      Customers.all(options)
    end

    def self.search(email, options = {})
      Customers.search(email, options)
    end

    def self.find_by_external_id(external_id)
      all(external_id: external_id).first
    end

    def self.merge!(into_uuid:, from_uuid:)
      options = {
        from: { customer_uuid: from_uuid },
        into: { customer_uuid: into_uuid }
      }
      custom!(:post, '/v1/customers/merges', options)
      true
    end

    def self.unmerge!(customer_uuid:, data_source_uuid:, external_id:, move_to_new_customer: [])
      options = {
        customer_uuid: customer_uuid,
        data_source_uuid: data_source_uuid,
        external_id: external_id,
        move_to_new_customer: move_to_new_customer
      }
      custom!(:post, '/v1/customers/unmerges', options)
      true
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

    def contacts(options = {})
      Contacts.all(options.merge(customer_uuid: uuid))
    end

    def create_contact(options = {})
      Contact.create!(options.merge(customer_uuid: uuid))
    end

    def notes(options = {})
      Notes.all(options.merge(customer_uuid: uuid))
    end

    def create_note(options = {})
      Note.create!(options.merge(customer_uuid: uuid))
    end

    def opportunities(options = {})
      Opportnities.all(options.merge(customer_uuid: uuid))
    end

    def create_opportunity(options = {})
      Opportunity.create!(options.merge(customer_uuid: uuid))
    end

    # Enrichment
    def tags
      @attributes[:tags]
    end

    def custom_attributes
      @attributes[:custom]
    end

    def add_tags!(*tags)
      self.tags = custom_without_assign!(:post,
                                         "/v1/customers/#{uuid}/attributes/tags",
                                         tags: tags)[:tags]
    end

    def remove_tags!(*tags)
      self.tags = custom_without_assign!(:delete,
                                         "/v1/customers/#{uuid}/attributes/tags",
                                         tags: tags)[:tags]
    end

    def add_custom_attributes!(*custom_attrs)
      self.custom_attributes = custom_without_assign!(:post,
                                                      "/v1/customers/#{uuid}/attributes/custom",
                                                      custom: custom_attrs)[:custom]
    end

    def update_custom_attributes!(custom_attrs = {})
      self.custom_attributes = custom_without_assign!(:put,
                                                      "/v1/customers/#{uuid}/attributes/custom",
                                                      custom: custom_attrs)[:custom]
    end

    def remove_custom_attributes!(*custom_attrs)
      self.custom_attributes = custom_without_assign!(:delete,
                                                      "/v1/customers/#{uuid}/attributes/custom",
                                                      custom: custom_attrs)
    end

    def merge_into!(other_customer)
      options = {
        from: { customer_uuid: uuid },
        into: { customer_uuid: other_customer.uuid }
      }
      custom!(:post, '/v1/customers/merges', options)
      true
    end

    def unmerge!(data_source_uuid:, external_id:, move_to_new_customer: [])
      options = {
        customer_uuid: uuid,
        data_source_uuid: data_source_uuid,
        external_id: external_id,
        move_to_new_customer: move_to_new_customer
      }
      custom!(:post, '/v1/customers/unmerges', options)
      true
    end

    private

    def tags=(tags)
      @attributes[:tags] = tags
    end

    def custom_attributes=(custom_attributes = {})
      @attributes[:custom] = ChartMogul::Utils::JSONParser.typecast_custom_attributes(custom_attributes)
    end

    def set_attributes(attributes_attributes)
      @attributes = attributes_attributes
      @attributes[:custom] = ChartMogul::Utils::JSONParser.typecast_custom_attributes(attributes_attributes[:custom])
    end
  end

  class Customers < APIResource
    set_resource_name 'Customers'
    set_resource_path '/v1/customers'
    set_immutable_keys(%i[attributes custom])

    include Concerns::Entries
    include API::Actions::Custom
    include Concerns::Pageable
    include Concerns::Pageable2
    include Concerns::PageableWithCursor

    set_entry_class Customer

    def self.search(email, options = {})
      path = ChartMogul::ResourcePath.new('/v1/customers/search')
      custom!(:get, path.apply_with_get_params(options.merge(email: email)))
    end
  end
  # rubocop:enable Metrics/ClassLength
end
