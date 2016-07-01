shared_examples 'Summary' do
  it 'should have summary' do
    response = do_request

    expect(response).to respond_to(:summary)
    summary = response.summary

    expect(summary).to be_kind_of(ChartMogul::Summary)
    expect(summary.percentage_change).not_to be_nil
    expect(summary.previous).not_to be_nil
    expect(summary.current).not_to be_nil
  end
end
