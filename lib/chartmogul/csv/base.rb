module ChartMogul
  module CSV
    class Base < ChartMogul::Object
      def self.fields
        attributes.to_a
      end

      def to_a
        self.class.fields.map { |attribute| send(attribute) }
      end
    end
  end
end