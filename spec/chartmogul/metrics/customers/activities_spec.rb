# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared/pageable'

describe ChartMogul::Metrics::Customers::Activity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Customers::Activity.all('cus_23551596-2c7e-11ee-9ea1-2bfe193640c0') }

  it_behaves_like 'Pageable'

  it 'should have Activity entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Customers::Activities)
    expect(response.count).to be > 0
    expect(response.cursor).not_to be_nil

    activity = response[0]
    expect(activity).to be_kind_of(ChartMogul::Metrics::Customers::Activity)
    expect(activity.id).not_to be_nil
    expect(activity.description).not_to be_nil
    expect(activity.type).not_to be_nil
    expect(activity.date).not_to be_nil
    expect(activity.activity_arr).not_to be_nil
    expect(activity.activity_mrr).not_to be_nil
    expect(activity.activity_mrr_movement).not_to be_nil
    expect(activity.currency).not_to be_nil
    expect(activity.currency_sign).not_to be_nil
    expect(activity.subscription_external_id).not_to be_nil
  end

  it 'should paginate using cursor when called with #next' do
    customer_uuid = 'cus_23551596-2c7e-11ee-9ea1-2bfe193640c0'
    activities = ChartMogul::Metrics::Customers::Activity.all(customer_uuid, per_page: 1)
    expect(activities.size).to eq(1)
    expect(activities[0].id).to eq(2625867088)

    next_activities = activities.next(customer_uuid, per_page: 1)
    expect(next_activities.size).to eq(1)
    expect(next_activities[0].id).to eq(2625867087)
  end
end
