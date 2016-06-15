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
        define_reader(attribute)
        define_private_writer(attribute, options[:type])
      end

      def writeable_attr(attribute, options = {})
        attributes << attribute.to_sym
        writeable_attributes << attribute.to_sym

        define_reader(attribute)
        define_writer(attribute)
        define_private_writer(attribute, options[:type])
      end

      def define_reader(attribute)
        class_eval <<-"end_eval", __FILE__, __LINE__
          def #{attribute}
            @#{attribute}
          end
        end_eval
      end

      def define_private_writer(attribute, type)
        if type == :time
          class_eval <<-"end_eval", __FILE__, __LINE__
            private
            def set_#{attribute}(value)
              @#{attribute} = Time.parse(value)
            end
          end_eval
        else
          class_eval <<-"end_eval", __FILE__, __LINE__
            private
            def set_#{attribute}(value)
              @#{attribute} = value
            end
          end_eval
        end
      end

      def define_writer(attribute)
        class_eval <<-"end_eval", __FILE__, __LINE__
          def #{attribute}=(value)
            @#{attribute} = value
          end
        end_eval
      end
    end

    def writeable_attributes
      self.class.writeable_attributes
    end

    def attributes
      self.class.attributes
    end

    def initialize(attributes = {})
      assign_writeable_attributes(attributes)
    end

    def self.new_from_json(attributes={})
      self.new.tap do |resource|
        resource.assign_all_attributes(attributes)
      end
    end

    def assign_writeable_attributes(new_values)
      writeable_attributes.each do |attr, value|
        self.send("#{attr}=", new_values[attr])
      end
    end

    def assign_all_attributes(new_values)
      attributes.each do |attr|
        self.send("set_#{attr}", new_values[attr])
      end
    end

    def serialize_for_write
      writeable_attributes.each_with_object({}) do |attr, attrs|
        attrs[attr] = self.send(attr)
      end
    end
  end
end
