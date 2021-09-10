# frozen_string_literal: true

module ChartMogul
  module ConfigAttributes
    def config_accessor(attribute, default_value = nil)
      define_method(attribute) do
        attr = config.send(attribute) || global_config.send(attribute) || default_value
        if attr.nil?
          raise ConfigurationError, "Configuration for #{attribute} not set"
        end

        attr
      end

      define_method("global_#{attribute}") do
        attr = global_config.send(attribute) || default_value
        if attr.nil?
          raise ConfigurationError, "Global configuration for #{attribute} not set"
        end

        attr
      end

      define_method("#{attribute}=") do |val|
        config.send("#{attribute}=", val)
        Thread.current[ChartMogul::APIResource::THREAD_CONNECTION_KEY] = nil
        val
      end

      define_method("global_#{attribute}=") do |val|
        global_config.send("#{attribute}=", val)
        Thread.current[ChartMogul::APIResource::THREAD_CONNECTION_KEY] = nil
        val
      end
    end
  end
end
