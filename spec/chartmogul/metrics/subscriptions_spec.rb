require 'spec_helper'
require_relative 'shared/pageable'

describe ChartMogul::Metrics::Subscription, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Subscription.all('cus_91af761e-9d0a-11e5-b514-1feab446feac') }

  it_behaves_like 'Pageable'

  it 'should have Subscription entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::SubscriptionEntries)
    expect(response.count).to be > 0

    subscription = response[0]
    expect(subscription).to be_kind_of(ChartMogul::Metrics::Subscription)
    expect(subscription.id).to_not be_nil
    expect(subscription.plan).to_not be_nil
    expect(subscription.quantity).to_not be_nil
    expect(subscription.mrr).to_not be_nil
    expect(subscription.arr).to_not be_nil
    expect(subscription.status).to_not be_nil
    expect(subscription.billing_cycle).to_not be_nil
    expect(subscription.billing_cycle_count).to_not be_nil
    expect(subscription.start_date).to be_kind_of(Time)
    expect(subscription.end_date).to be_kind_of(Time)
    expect(subscription.currency).to_not be_nil
    expect(subscription.currency_sign).to_not be_nil
  end
end

