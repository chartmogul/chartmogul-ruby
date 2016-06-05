require 'time'
require 'json'
require 'faraday'

require "chartmogul/version"

require "chartmogul/errors/chartmogul_error"
require "chartmogul/errors/not_found_error"
require "chartmogul/errors/configuration_error"
require "chartmogul/errors/resource_invalid_error"

require "chartmogul/config_attributes"
require "chartmogul/configuration"

require "chartmogul/object"
require "chartmogul/api_resource"
require "chartmogul/api/actions/all"
require "chartmogul/api/actions/create"
require "chartmogul/api/actions/destroy"

require "chartmogul/import/data_source"

module ChartMogul
  API_BASE = 'https://api.chartmogul.com'

  class << self
    extend ConfigAttributes

    def config
      @config ||= ChartMogul::Configuration.new
    end

    config_accessor :account_token
    config_accessor :secret_key
  end
end
