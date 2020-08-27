# frozen_string_literal: true

module ChartMogul
  module CSV
    module BaseStruct
      # to have same behaviour as keyword_init=true introduced in Ruby 2.5
      def initialize(hash)
        hash.each do |key, value|
          send("#{key}=", value)
        end
      end
    end
  end
end
