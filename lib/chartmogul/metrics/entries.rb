module ChartMogul
  module Metrics
    module Entries
      def self.included(base)
        base.extend ClassMethods
        base.send :prepend, InstanceMethods

        base.instance_eval do
          readonly_attr :entries, default: []
          readonly_attr :summary

          include API::Actions::All

          def_delegators :entries, :each, :[], :<<, :size, :length
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

      module InstanceMethods
        def set_summary(summary_attributes)
          @summary = Summary.new_from_json(summary_attributes)
        end

        def set_entries(entries_attributes)
          @entries = entries_attributes.map do |entity|
            self.class.get_entry_class.new_from_json(entity)
          end
        end
      end
    end
  end
end
