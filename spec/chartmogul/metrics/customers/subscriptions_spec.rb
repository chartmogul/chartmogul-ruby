# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared/pageable'

describe ChartMogul::Metrics::Customers::Subscription, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Customers::Subscription.all('cus_23551596-2c7e-11ee-9ea1-2bfe193640c0') }

  it_behaves_like 'Pageable'

  it 'should have Subscription entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Customers::Subscriptions)
    expect(response.count).to be > 0
    expect(response.cursor).not_to be_nil

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

  it 'should paginate using cursor when called with #next' do
    customer_uuid = 'cus_23551596-2c7e-11ee-9ea1-2bfe193640c0'
    subscriptions = ChartMogul::Metrics::Customers::Subscription.all(customer_uuid, per_page: 1)
    expect(subscriptions.size).to eq(1)
    expect(subscriptions[0].id).to eq(2293710870)

    next_subscriptions = subscriptions.next(customer_uuid, per_page: 1)
    expect(next_subscriptions.size).to eq(0)
  end
end
