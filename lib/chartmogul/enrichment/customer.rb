# frozen_string_literal: true

module ChartMogul
  module Enrichment
    # <b>DEPRECATED:</b> Please use <tt>ChartMogul/Customer</tt> instead.
    class DeprecatedCustomer < APIResource
      set_resource_name 'Customer'
      set_resource_path '/v1/customers'

      readonly_attr :id
      readonly_attr :uuid
      readonly_attr :external_id
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

      writeable_attr :name
      writeable_attr :email
      writeable_attr :company
      writeable_attr :country
      writeable_attr :state
      writeable_attr :city
      writeable_attr :lead_created_at
      writeable_attr :free_trial_started_at
      writeable_attr :attributes

      include API::Actions::Custom
      include API::Actions::Retrieve
      include API::Actions::Update

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
                                                        custom: custom_attrs)[:custom]
      end

      def merge_into!(other_customer)
        options = {
          from: { customer_uuid: uuid },
          into: { customer_uuid: other_customer.uuid }
        }
        custom!(:post, '/v1/customers/merges', options)
        true
      end

      def self.all(options = {})
        Customers.all(options)
      end

      def self.search(email)
        Customers.search(email)
      end

      private

      def tags=(tags)
        @attributes[:tags] = tags
      end

      # When passing timestamps, either use Time instance, or iso8601-parseable string.
      def custom_attributes=(custom_attributes = {})
        @attributes[:custom] = ChartMogul::Utils::JSONParser.typecast_custom_attributes(custom_attributes)
      end

      def set_attributes(attributes_attributes)
        @attributes = attributes_attributes
        @attributes[:custom] = ChartMogul::Utils::JSONParser.typecast_custom_attributes(attributes_attributes[:custom])
      end
    end

    def self.const_missing(const_name)
      super unless const_name == :Customer
      warn 'DEPRECATION WARNING: the class ChartMogul::Enrichment::Customer is deprecated. Use ChartMogul::Customer instead.'
      DeprecatedCustomer
    end

    class Customers < APIResource
      set_resource_name 'Customers'
      set_resource_path '/v1/customers'

      include Concerns::Entries
      include API::Actions::Custom
      include Concerns::Pageable
      include Concerns::PageableWithCursor

      set_entry_class DeprecatedCustomer

      def self.search(email)
        path = ChartMogul::ResourcePath.new('/v1/customers/search')
        custom!(:get, path.apply_with_get_params(email: email))
      end
    end
  end
end
