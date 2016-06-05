require "chartmogul/version"

require "chartmogul/errors/chartmogul_error"
require "chartmogul/errors/not_found_error"
require "chartmogul/errors/configuration_error"

require "chartmogul/config_attributes"
require "chartmogul/configuration"

module ChartMogul


  class << self
    extend ConfigAttributes

    def config
      @config ||= ChartMogul::Configuration.new
    end

    config_accessor :account_token
    config_accessor :secret_key
  end
end
