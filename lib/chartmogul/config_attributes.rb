module ChartMogul
  module ConfigAttributes
    def config_accessor(attribute)
      define_method(attribute) do
        attr = config.send(attribute)
        raise ConfigurationError.new("Configuration for #{attribute} not set") if attr.nil?
        attr
      end

      define_method("#{attribute}=") do |val|
        config.send("#{attribute}=", val)
      end
    end
  end
end
