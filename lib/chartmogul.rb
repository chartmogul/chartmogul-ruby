# frozen_string_literal: true

require 'time'
require 'json'
require 'faraday'

require 'chartmogul/version'

require 'chartmogul/utils/hash_snake_caser'
require 'chartmogul/utils/json_parser'

require 'chartmogul/errors/chartmogul_error'
require 'chartmogul/errors/configuration_error'
require 'chartmogul/errors/forbidden_error'
require 'chartmogul/errors/not_found_error'
require 'chartmogul/errors/resource_invalid_error'
require 'chartmogul/errors/schema_invalid_error'
require 'chartmogul/errors/server_error'
require 'chartmogul/errors/unauthorized_error'

require 'chartmogul/config_attributes'
require 'chartmogul/configuration'

require 'chartmogul/object'
require 'chartmogul/resource_path'
require 'chartmogul/api_resource'
require 'chartmogul/summary'

require 'chartmogul/api/actions/all'
require 'chartmogul/api/actions/create'
require 'chartmogul/api/actions/custom'
require 'chartmogul/api/actions/destroy'
require 'chartmogul/api/actions/retrieve'
require 'chartmogul/api/actions/update'

require 'chartmogul/line_items/one_time'
require 'chartmogul/line_items/subscription'

require 'chartmogul/transactions/payment'
require 'chartmogul/transactions/refund'

require 'chartmogul/concerns/entries'
require 'chartmogul/concerns/summary'
require 'chartmogul/concerns/pageable'
require 'chartmogul/concerns/pageable2'

require 'chartmogul/subscription'
require 'chartmogul/invoice'
require 'chartmogul/customer_invoices'
require 'chartmogul/customer'
require 'chartmogul/data_source'
require 'chartmogul/ping'
require 'chartmogul/plan'
require 'chartmogul/plan_group'
require 'chartmogul/plan_groups/plans'

require 'chartmogul/metrics/arpa'
require 'chartmogul/metrics/arr'
require 'chartmogul/metrics/asp'
require 'chartmogul/metrics/customer_churn_rate'
require 'chartmogul/metrics/customer_count'
require 'chartmogul/metrics/ltv'
require 'chartmogul/metrics/mrr'
require 'chartmogul/metrics/mrr_churn_rate'
require 'chartmogul/metrics/all_key_metrics'
require 'chartmogul/metrics/base'

require 'chartmogul/metrics/activity'
require 'chartmogul/metrics/subscription'

require 'chartmogul/enrichment/customer'

require 'chartmogul/csv/csv_header'
require 'chartmogul/csv/base_struct'
require 'chartmogul/csv/invoice'
require 'chartmogul/csv/customer'
require 'chartmogul/csv/plan'
require 'chartmogul/csv/line_items/subscription'
require 'chartmogul/csv/line_items/one_time'
require 'chartmogul/csv/transaction'
require 'chartmogul/csv/cancellation'

module ChartMogul
  API_BASE = 'https://api.chartmogul.com'
  MAX_RETRIES = 20
  CONFIG_THREAD_KEY = 'chartmogul_ruby.config'

  class << self
    extend ConfigAttributes


    def config
      Thread.current[CONFIG_THREAD_KEY] = ChartMogul::Configuration.new if Thread.current[CONFIG_THREAD_KEY].nil?
      Thread.current[CONFIG_THREAD_KEY]
    end

    config_accessor :account_token
    config_accessor :secret_key
    config_accessor :max_retries, MAX_RETRIES
    config_accessor :api_base, API_BASE
  end
end
