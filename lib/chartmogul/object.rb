require 'set'

module ChartMogul
  class Object
    class << self
      def attributes
        @attributes ||= Set.new
      end

      def writeable_attributes
        @writeable_attributes ||= Set.new
      end

      def readonly_attr(attribute, options = {})
        attributes << attribute.to_sym
        define_reader(attribute, options[:default])
        define_private_writer(attribute, options[:type])
      end

      def writeable_attr(attribute, options = {})
        attributes << attribute.to_sym
        writeable_attributes << attribute.to_sym

        define_reader(attribute, options[:default])
        define_writer(attribute)
        define_private_writer(attribute, options[:type])
      end

      def define_reader(attribute, default)
        define_method(attribute) do
          if instance_variable_defined?("@#{attribute}")
            instance_variable_get("@#{attribute}")
          else
            instance_variable_set("@#{attribute}", default)
          end
        end
      end

      def define_private_writer(attribute, type)
        if type == :time
          define_method("set_#{attribute}") do |value|
            instance_variable_set("@#{attribute}", value && Time.parse(value))
          end
        else
          define_method("set_#{attribute}") do |value|
            instance_variable_set("@#{attribute}", value)
          end
        end
        private "set_#{attribute}"
      end

      def define_writer(attribute)
        define_method("#{attribute}=") do |value|
          instance_variable_set("@#{attribute}", value)
        end
      end
    end

    def initialize(attributes = {})
      assign_writeable_attributes(attributes)
    end

    def self.new_from_json(attributes={})
      self.new.tap do |resource|
        resource.assign_all_attributes(attributes)
      end
    end

    def instance_attributes
      self.class.attributes.each_with_object({}) do |attribute, hash|
        hash[attribute] = send(attribute)
      end
    end

    def assign_writeable_attributes(new_values)
      self.class.writeable_attributes.each do |attr, value|
        self.send("#{attr}=", new_values[attr]) if new_values.key?(attr)
      end

      self
    end

    def assign_all_attributes(new_values)
      self.class.attributes.each do |attr|
        self.send("set_#{attr}", new_values[attr]) if new_values.key?(attr)
      end

      self
    end

    def serialize_for_write
      self.class.writeable_attributes.each_with_object({}) do |attr, attrs|
        serialized_value = serialized_value_for_attr(attr)
        attrs[attr] = serialized_value if allowed_for_write?(serialized_value)
      end
    end

    def allowed_for_write?(serialized_value)
      return false if serialized_value.is_a?(Array) && serialized_value.empty?
      return false if serialized_value.nil?

      true
    end

    def serialized_value_for_attr(attr)
      serialize_method_name = "serialize_#{attr}"

      if respond_to?(serialize_method_name)
        send(serialize_method_name)
      else
        send(attr)
      end
    end
  end
end
