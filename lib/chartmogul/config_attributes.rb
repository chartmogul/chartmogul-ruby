module ChartMogul
  module ConfigAttributes
    def config_accessor(attribute, default_value = nil)
      define_method(attribute) do
        attr = config.send(attribute) || default_value
        raise ConfigurationError, "Configuration for #{attribute} not set" if attr.nil?
        attr
      end

      define_method("#{attribute}=") do |val|
        config.send("#{attribute}=", val)
      end
    end
  end
end
