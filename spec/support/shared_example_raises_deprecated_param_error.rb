# frozen_string_literal: true

shared_examples 'raises deprecated param error' do
  it 'raises a DeprecatedParameter error' do
    expect { get_resources }.to raise_error(ChartMogul::ChartMogulError, 'page is deprecated.')
  end
end
