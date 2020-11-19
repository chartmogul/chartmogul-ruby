# frozen_string_literal: true

module ChartMogul
  module CSV
    class Base < ChartMogul::Object
      def self.fields
        attributes.to_a
      end

      def to_a
        self.class.fields.map { |attribute| send(attribute) }
      end

      def to_h
        self.class.fields.inject({}) { |res, el| res.merge({ "#{el}": send(el) }) }
      end
    end
  end
end
