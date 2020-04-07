# frozen_string_literal: true

require 'spec_helper'
require_relative 'shared/metrics_resource'

METRICS = {
  arpa: ChartMogul::Metrics::ARPA,
  arr: ChartMogul::Metrics::ARR,
  asp: ChartMogul::Metrics::ASP,
  ltv: ChartMogul::Metrics::LTV,
  customer_churn_rate: ChartMogul::Metrics::CustomerChurnRate,
  customer_count: ChartMogul::Metrics::CustomerCount,
  mrr_churn_rate: ChartMogul::Metrics::MRRChurnRate
}.freeze

METRICS.each do |method_name, klass_name|
  describe klass_name, vcr: true, uses_api: true do
    let(:value_field) { method_name == :customer_count ? :customers : method_name }
    let(:do_request) { ChartMogul::Metrics.send(method_name, start_date: '2015-01-01', end_date: '2015-02-01') }

    it_behaves_like 'Metrics API resource'
  end
end
