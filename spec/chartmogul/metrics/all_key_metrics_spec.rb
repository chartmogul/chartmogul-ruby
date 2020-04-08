# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Metrics::AllKeyMetric, vcr: true, uses_api: true do
  it 'should have entries' do
    response = ChartMogul::Metrics.all(start_date: '2015-01-01', end_date: '2015-02-01')
    expect(response.count).not_to be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    expect(entry.arpa).not_to be_nil
    expect(entry.arr).not_to be_nil
    expect(entry.asp).not_to be_nil
    expect(entry.customer_churn_rate).not_to be_nil
    expect(entry.customers).not_to be_nil
    expect(entry.ltv).not_to be_nil
    expect(entry.mrr).not_to be_nil
    expect(entry.mrr_churn_rate).not_to be_nil
  end
end
