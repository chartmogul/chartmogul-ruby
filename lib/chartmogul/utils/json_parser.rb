module ChartMogul
  module Utils
    class JSONParser
      def self.parse(json_string)
        hash = JSON.parse(json_string, symbolize_names: true)
        HashSnakeCaser.new(hash).to_snake_keys
      end
    end
  end
end
