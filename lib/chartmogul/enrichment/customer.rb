module ChartMogul
  module Enrichment
    class Customer < APIResource
      set_resource_name 'Customer'

      readonly_attr :id
      readonly_attr :uuid
      readonly_attr :external_id
      readonly_attr :name
      readonly_attr :email
      readonly_attr :status
      readonly_attr :customer_since, type: :time
      readonly_attr :attributes
      readonly_attr :address
      readonly_attr :mrr
      readonly_attr :arr
      readonly_attr :billing_system_url
      readonly_attr :chartmogul_url
      readonly_attr :billing_system_type
      readonly_attr :currency
      readonly_attr :currency_sign

      include API::Actions::Custom

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

      def self.retrieve(customer_uuid)
        custom!(:get, "/v1/customers/#{customer_uuid}")
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

      def custom_attributes=(custom_attributes = {})
        @attributes[:custom] = typecast_custom_attributes(custom_attributes)
      end

      def set_attributes(attributes_attributes)
        @attributes = attributes_attributes
        @attributes[:custom] = typecast_custom_attributes(attributes_attributes[:custom])
      end

      def typecast_custom_attributes(custom_attributes)
        return {} unless custom_attributes
        custom_attributes.each_with_object({}) do |(key, value), hash|
          hash[key] = value.instance_of?(String) ? (Time.parse(value) rescue value) : value
        end
      end
    end

    class Customers < APIResource
      set_resource_name 'Customers'
      set_resource_path '/v1/customers'

      include Concerns::Entries
      include API::Actions::Custom
      include Concerns::Pageable

      set_entry_class Customer

      def self.search(email)
        path = ChartMogul::ResourcePath.new('/v1/customers/search')
        custom!(:get, path.apply_with_get_params(email: email))
      end
    end
  end
end
