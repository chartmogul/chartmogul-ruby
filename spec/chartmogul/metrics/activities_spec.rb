# frozen_string_literal: true

require 'spec_helper'
require_relative 'shared/pageable_with_anchor'

describe ChartMogul::Metrics::Activity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Activity.all({ per_page: 2 }) }

  it_behaves_like 'PageableWithAnchor'

  it 'should have Activity entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Activities)
    expect(response.count).to be > 0
    expect(response.cursor).not_to be_nil

    activity = response[0]
    expect(activity).to be_kind_of(ChartMogul::Metrics::Activity)
    expect(activity.description).not_to be_nil
    expect(activity.type).not_to be_nil
    expect(activity.date).not_to be_nil
    expect(activity.activity_arr).not_to be_nil
    expect(activity.activity_mrr).not_to be_nil
    expect(activity.activity_mrr_movement).not_to be_nil
    expect(activity.currency).not_to be_nil
    expect(activity.subscription_external_id).not_to be_nil
    expect(activity.subscription_set_external_id).not_to be_nil
    expect(activity.plan_external_id).not_to be_nil
    expect(activity.customer_name).not_to be_nil
    expect(activity.customer_uuid).not_to be_nil
    expect(activity.customer_external_id).not_to be_nil
    expect(activity.billing_connector_uuid).not_to be_nil
    expect(activity.uuid).not_to be_nil
  end

  it 'should paginate using cursor when called with #next' do
    activities = ChartMogul::Metrics::Activity.all(per_page: 1)
    expect(activities.size).to eq(1)
    expect(activities[0].uuid).to eq('561814e1-d7d3-42f3-8936-4689ec0fbb74')

    next_activities = activities.next(per_page: 1)
    expect(next_activities.size).to eq(1)
    expect(next_activities[0].uuid).to eq('d868a892-37c7-45e3-ae84-e693181d2344')
  end
end
