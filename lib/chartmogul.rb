require 'time'
require 'json'
require 'faraday'

require "chartmogul/version"

require "chartmogul/utils/hash_snake_caser"
require "chartmogul/utils/json_parser"

require "chartmogul/errors/chartmogul_error"
require "chartmogul/errors/not_found_error"
require "chartmogul/errors/configuration_error"
require "chartmogul/errors/resource_invalid_error"
require "chartmogul/errors/schema_invalid_error"

require "chartmogul/config_attributes"
require "chartmogul/configuration"

require "chartmogul/object"
require "chartmogul/resource_path"
require "chartmogul/api_resource"
require "chartmogul/summary"

require "chartmogul/api/actions/all"
require "chartmogul/api/actions/create"
require "chartmogul/api/actions/update"
require "chartmogul/api/actions/destroy"
require "chartmogul/api/actions/custom"

require "chartmogul/import/line_items/one_time"
require "chartmogul/import/line_items/subscription"

require "chartmogul/import/transactions/payment"
require "chartmogul/import/transactions/refund"

require "chartmogul/import/invoice"
require "chartmogul/import/customer_invoices"

require "chartmogul/import/subscription"
require "chartmogul/import/customer"
require "chartmogul/import/data_source"
require "chartmogul/import/plan"

require "chartmogul/concerns/entries"
require "chartmogul/concerns/summary"
require "chartmogul/concerns/pageable"

require "chartmogul/metrics/arpa"
require "chartmogul/metrics/arr"
require "chartmogul/metrics/asp"
require "chartmogul/metrics/customer_churn_rate"
require "chartmogul/metrics/customer_count"
require "chartmogul/metrics/ltv"
require "chartmogul/metrics/mrr"
require "chartmogul/metrics/mrr_churn_rate"
require "chartmogul/metrics/all_key_metrics"
require "chartmogul/metrics/base"

require "chartmogul/metrics/activity"
require "chartmogul/metrics/subscription"

require "chartmogul/enrichment/customer"

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
