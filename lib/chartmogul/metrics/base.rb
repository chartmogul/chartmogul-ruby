module ChartMogul
  module Metrics

    def self.all(options = {})
      ChartMogul::Metrics::AllKeyMetrics.all(preprocess_params(options))
    end

    def self.arpa(options = {})
      ChartMogul::Metrics::ARPAs.all(preprocess_params(options))
    end

    def self.arr(options = {})
      ChartMogul::Metrics::ARRs.all(preprocess_params(options))
    end

    def self.asp(options = {})
      ChartMogul::Metrics::ASPs.all(preprocess_params(options))
    end

    def self.customer_churn_rate(options = {})
      ChartMogul::Metrics::CustomerChurnRates.all(preprocess_params(options))
    end

    def self.customer_count(options = {})
      ChartMogul::Metrics::CustomerCounts.all(preprocess_params(options))
    end

    def self.mrr(options = {})
      ChartMogul::Metrics::MRRs.all(preprocess_params(options))
    end

    def self.ltv(options = {})
      ChartMogul::Metrics::LTVs.all(preprocess_params(options))
    end

    def self.mrr_churn_rate(options = {})
      ChartMogul::Metrics::MRRChurnRates.all(preprocess_params(options))
    end

    private

    def self.preprocess_params(options)
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

