require 'spec_helper'
require_relative 'shared/summary'

describe ChartMogul::Metrics::MrrEntity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics.mrr(start_date: '2015-01-01', end_date: '2015-02-01') }

  it_behaves_like 'Summary'

  it 'should have entries' do
    response = do_request
    expect(response.count).to_not be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    expect(entry.mrr).to_not be_nil
    expect(entry.mrr_new_business).to_not be_nil
    expect(entry.mrr_expansion).to_not be_nil
    expect(entry.mrr_churn).to_not be_nil
    expect(entry.mrr_reactivation).to_not be_nil
  end
end
