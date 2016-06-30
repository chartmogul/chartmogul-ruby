require 'spec_helper'
require_relative 'shared_examples'

{
  arpa: 'ArpaEntity', arr: 'ArrEntity', asp: 'AspEntity', ltv: 'LtvEntity',
  customer_churn_rate: 'CustomerChurnRateEntity', customer_count: 'CustomerCountEntity', mrr_churn_rate: 'MrrChurnRateEntity'
}.each do |method_name, klass_name|
  klass = Object.const_get("ChartMogul::Metrics::#{klass_name}")

  describe klass, vcr: true, uses_api: true do
    let(:value_field) { method_name == :customer_count ? :customers : method_name }
    let(:do_request) { ChartMogul::Metrics.send(method_name, start_date: '2015-01-01', end_date: '2015-02-01') }

    include_examples 'Metrics API resource'
  end
end
