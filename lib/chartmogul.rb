# frozen_string_literal: true

require 'time'
require 'json'
require 'faraday'
require 'faraday/retry'

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
require 'chartmogul/errors/deprecated_parameter_error'

require 'chartmogul/config_attributes'
require 'chartmogul/configuration'

require 'chartmogul/object'
require 'chartmogul/resource_path'
require 'chartmogul/api_resource'
require 'chartmogul/summary'
require 'chartmogul/summary_all'

require 'chartmogul/api/actions/all'
require 'chartmogul/api/actions/create'
require 'chartmogul/api/actions/custom'
require 'chartmogul/api/actions/destroy'
require 'chartmogul/api/actions/destroy_with_params'
require 'chartmogul/api/actions/retrieve'
require 'chartmogul/api/actions/update'

require 'chartmogul/line_items/one_time'
require 'chartmogul/line_items/subscription'

require 'chartmogul/transactions/payment'
require 'chartmogul/transactions/refund'

require 'chartmogul/concerns/entries'
require 'chartmogul/concerns/summary'
require 'chartmogul/concerns/summary_all'
require 'chartmogul/concerns/pageable'
require 'chartmogul/concerns/pageable2'
require 'chartmogul/concerns/pageable_with_anchor'
require 'chartmogul/concerns/pageable_with_cursor'

require 'chartmogul/subscription'
require 'chartmogul/invoice'
require 'chartmogul/customer_invoices'
require 'chartmogul/customer'
require 'chartmogul/contact'
require 'chartmogul/data_source'
require 'chartmogul/ping'
require 'chartmogul/plan'
require 'chartmogul/plan_group'
require 'chartmogul/plan_groups/plans'
require 'chartmogul/account'
require 'chartmogul/subscription_event'

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

require 'chartmogul/metrics/customers/activity'
require 'chartmogul/metrics/customers/subscription'
require 'chartmogul/metrics/activity'
require 'chartmogul/metrics/activities_export'

require 'chartmogul/enrichment/customer'

module ChartMogul
  API_BASE = 'https://api.chartmogul.com'
  MAX_RETRIES = 20
  CONFIG_THREAD_KEY = 'chartmogul_ruby.config'

  class << self
    extend ConfigAttributes

    def global_config
      @global_config ||= ChartMogul::Configuration.new
    end

    # This configuration is thread-safe and fits multi-account async
    # jobs processing use case.
    def config
      Thread.current[CONFIG_THREAD_KEY] ||= ChartMogul::Configuration.new
    end

    config_accessor :api_key
    config_accessor :max_retries, MAX_RETRIES
    config_accessor :api_base, API_BASE
  end
end
