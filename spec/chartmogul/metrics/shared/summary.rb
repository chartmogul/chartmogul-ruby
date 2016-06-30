shared_examples 'Summary' do
  it 'should have summary' do
    response = do_request

    expect(response).to respond_to(:summary)
    summary = response.summary

    expect(summary).to be_kind_of(ChartMogul::Metrics::Summary)
    expect(summary.percentage_change).to_not be_nil
    expect(summary.previous).to_not be_nil
    expect(summary.current).to_not be_nil
  end
end
