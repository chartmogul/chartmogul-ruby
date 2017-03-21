module ChartMogul
  module Concerns
    module Entries
      def self.included(base)
        base.extend ClassMethods

        base.instance_eval do
          if @resource_root_key.nil?
            @resource_root_key = :entries
          end
          readonly_attr @resource_root_key, default: []

          include API::Actions::All

          include Enumerable
          def_delegators @resource_root_key, :each, :[], :<<, :size, :length, :empty?, :first

          resource_root_key = @resource_root_key.to_s
          base.send :define_method, "set_" + resource_root_key do |entries|
            objects = entries.map do |entity|
              self.class.get_entry_class.new_from_json(entity)
            end
            self.instance_variable_set "@#{resource_root_key}", objects
          end
        end
      end

      module ClassMethods
        def set_entry_class(klass)
          instance_variable_set("@entry_class", klass)
        end

        def get_entry_class
          instance_variable_get("@entry_class")
        end
      end
    end
  end
end
