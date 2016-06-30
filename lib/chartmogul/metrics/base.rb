module ChartMogul
  module Metrics

    def self.all(options = {})
      ChartMogul::Metrics::AllKeyMetricsEntries.all(preprocess_list_params(options))
    end

    def self.arpa(options = {})
      ChartMogul::Metrics::ArpaEntries.all(preprocess_list_params(options))
    end

    def self.arr(options = {})
      ChartMogul::Metrics::ArrEntries.all(preprocess_list_params(options))
    end

    def self.asp(options = {})
      ChartMogul::Metrics::AspEntries.all(preprocess_list_params(options))
    end

    def self.customer_churn_rate(options = {})
      ChartMogul::Metrics::CustomerChurnRateEntries.all(preprocess_list_params(options))
    end

    def self.customer_count(options = {})
      ChartMogul::Metrics::CustomerCountEntries.all(preprocess_list_params(options))
    end

    def self.mrr(options = {})
      ChartMogul::Metrics::MrrEntries.all(preprocess_list_params(options))
    end

    def self.ltv(options = {})
      ChartMogul::Metrics::LtvEntries.all(preprocess_list_params(options))
    end

    def self.mrr_churn_rate(options = {})
      ChartMogul::Metrics::MrrChurnRateEntries.all(preprocess_list_params(options))
    end

    private
    def self.preprocess_list_params(options)
      [:start_date, :end_date].each do |param_name|
        options[param_name.to_s.gsub('_', '-')] = options.delete(param_name) if options[param_name]
      end

      [:geo, :plans].each do |param_name|
        if options[param_name] && options[param_name].kind_of?(Array)
          options[param_name] = options[param_name].join(',')
        end
      end
      options
    end
  end
end

