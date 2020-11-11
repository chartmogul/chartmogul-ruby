# frozen_string_literal: true

require 'spec_helper'
require_relative 'shared/pageable'

describe ChartMogul::Metrics::Activity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Activity.all('cus_91af761e-9d0a-11e5-b514-1feab446feac') }

  it_behaves_like 'Pageable'

  it 'should have Activity entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::Activities)
    expect(response.count).to be > 0

    activity = response[0]
    expect(activity).to be_kind_of(ChartMogul::Metrics::Activity)
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
end
