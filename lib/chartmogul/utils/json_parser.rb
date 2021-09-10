# frozen_string_literal: true

module ChartMogul
  module Utils
    class JSONParser
      class << self
        def parse(json_string, immutable_keys: [])
          hash = JSON.parse(json_string, symbolize_names: true)
          HashSnakeCaser.new(hash, immutable_keys: immutable_keys).to_snake_keys
        end

        def typecast_custom_attributes(custom_attributes)
          return {} unless custom_attributes

          custom_attributes.each_with_object({}) do |(key, value), hash|
            hash[key] = opt_string_to_time(value)
          end
        end

        def opt_string_to_time(value)
          return value unless value.instance_of?(String)

          parse_timestamp(value)
        rescue ArgumentError
          value
        end

        def parse_timestamp(value)
          Time.iso8601(value)
        rescue ArgumentError
          Time.rfc2822(value)
        end
      end
    end
  end
end
