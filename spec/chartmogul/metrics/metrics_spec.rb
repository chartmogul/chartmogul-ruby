require 'spec_helper'
require_relative 'shared/metrics_resource'
require_relative 'shared/summary'

METRICS = {
  arpa: ChartMogul::Metrics::ArpaEntity,
  arr: ChartMogul::Metrics::ArrEntity,
  asp: ChartMogul::Metrics::AspEntity,
  ltv: ChartMogul::Metrics::LtvEntity,
  customer_churn_rate: ChartMogul::Metrics::CustomerChurnRateEntity,
  customer_count: ChartMogul::Metrics::CustomerCountEntity,
  mrr_churn_rate: ChartMogul::Metrics::MrrChurnRateEntity
}

METRICS.each do |method_name, klass_name|
  describe klass_name, vcr: true, uses_api: true do
    let(:value_field) { method_name == :customer_count ? :customers : method_name }
    let(:do_request) { ChartMogul::Metrics.send(method_name, start_date: '2015-01-01', end_date: '2015-02-01') }

    it_behaves_like 'Metrics API resource'
  end
end
