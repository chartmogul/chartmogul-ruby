# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Metrics::AllKeyMetric, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics.all(start_date: '2015-01-01', end_date: '2015-02-01') }
  let(:metrics) { %w[arpa arr asp customer_churn_rate customers ltv mrr] }

  it 'should have summary' do
    response = do_request

    expect(response).to respond_to(:summary)
    summary = response.summary

    expect(summary).to be_kind_of(ChartMogul::SummaryAll)
    metrics.each do |metric|
      expect(summary.public_send("#{metric}_percentage_change")).not_to be_nil
      expect(summary.public_send("previous_#{metric}")).not_to be_nil
      expect(summary.public_send("current_#{metric}")).not_to be_nil
    end
  end

  it 'should have entries' do
    response = do_request
    expect(response.count).not_to be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    metrics.each do |metric|
      expect(entry.public_send(metric)).not_to be_nil
      expect(entry.public_send("#{metric}_percentage_change")).not_to be_nil
    end
  end
end
