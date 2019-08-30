module ChartMogul
  module Utils
    class JSONParser
      class << self
        def parse(json_string)
          hash = JSON.parse(json_string, symbolize_names: true)
          HashSnakeCaser.new(hash).to_snake_keys
        end

        def typecast_custom_attributes(custom_attributes)
          return {} unless custom_attributes

          custom_attributes.each_with_object({}) do |(key, value), hash|
            hash[key] = opt_string_to_time(value)
          end
        end

        def opt_string_to_time(value)
          return value unless value.instance_of?(String)

          Time.iso8601(value) rescue Time.rfc2822(value) rescue value
        end
      end
    end
  end
end
