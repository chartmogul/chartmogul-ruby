require 'spec_helper'
require_relative 'shared/pageable'

describe ChartMogul::Metrics::Activity, vcr: true, uses_api: true do
  let(:do_request) { ChartMogul::Metrics::Activity.all('cus_91af761e-9d0a-11e5-b514-1feab446feac') }

  it_behaves_like 'Pageable'

  it 'should have Activity entries' do
    response = do_request

    expect(response).to be_kind_of(ChartMogul::Metrics::ActivityEntries)
    expect(response.count).to be > 0

    activity = response[0]
    expect(activity).to be_kind_of(ChartMogul::Metrics::Activity)
    expect(activity.id).to_not be_nil
    expect(activity.description).to_not be_nil
    expect(activity.type).to_not be_nil
    expect(activity.activity_arr).to_not be_nil
    expect(activity.activity_mrr).to_not be_nil
    expect(activity.activity_mrr_movement).to_not be_nil
    expect(activity.currency).to_not be_nil
    expect(activity.currency_sign).to_not be_nil
  end
end
