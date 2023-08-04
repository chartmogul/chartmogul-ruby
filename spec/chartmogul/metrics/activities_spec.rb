# frozen_string_literal: true

require 'spec_helper'
require_relative 'shared/pageable_with_cursor'

describe ChartMogul::Metrics::Activity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Activity.all({ per_page: 2 }) }

  it_behaves_like 'PageableWithCursor'

  it 'should have Activity entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Activities)
    expect(response.count).to be > 0

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
    expect(activity.plan_external_id).not_to be_nil
    expect(activity.customer_name).not_to be_nil
    expect(activity.customer_uuid).not_to be_nil
    expect(activity.customer_external_id).not_to be_nil
    expect(activity.billing_connector_uuid).not_to be_nil
    expect(activity.uuid).not_to be_nil
  end
end
