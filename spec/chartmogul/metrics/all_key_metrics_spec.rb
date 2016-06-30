require 'spec_helper'

describe ChartMogul::Metrics::AllKeyMetricsEntity, vcr: true, uses_api: true do
  it 'should have entries' do
    response = ChartMogul::Metrics.all(start_date: '2015-01-01', end_date: '2015-02-01')
    expect(response.count).to_not be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    expect(entry.arpa).to_not be_nil
    expect(entry.arr).to_not be_nil
    expect(entry.asp).to_not be_nil
    expect(entry.customer_churn_rate).to_not be_nil
    expect(entry.customers).to_not be_nil
    expect(entry.ltv).to_not be_nil
    expect(entry.mrr).to_not be_nil
    expect(entry.mrr_churn_rate).to_not be_nil
  end
end
