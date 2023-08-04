# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared/pageable_with_cursor'

describe ChartMogul::Metrics::Customers::Subscription, vcr: true, uses_api: true do
  let(:do_request) do
    ChartMogul::Metrics::Customers::Subscription.all('cus_521ffa10-5296-11ee-ad49-1f952cc8bc4f')
  end

  it_behaves_like 'PageableWithCursor'

  it 'should have Subscription entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Customers::Subscriptions)
    expect(response.count).to be > 0

    subscription = response[0]
    expect(subscription).to be_kind_of(ChartMogul::Metrics::Customers::Subscription)
    expect(subscription.id).not_to be_nil
    expect(subscription.plan).not_to be_nil
    expect(subscription.quantity).not_to be_nil
    expect(subscription.mrr).not_to be_nil
    expect(subscription.arr).not_to be_nil
    expect(subscription.status).not_to be_nil
    expect(subscription.billing_cycle).not_to be_nil
    expect(subscription.billing_cycle_count).not_to be_nil
    expect(subscription.start_date).to be_kind_of(Time)
    expect(subscription.end_date).to be_kind_of(Time)
    expect(subscription.currency).not_to be_nil
    expect(subscription.currency_sign).not_to be_nil
  end
end
