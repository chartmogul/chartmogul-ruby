shared_examples 'Metrics API resource' do
  it 'should have summary' do
    response = do_request
    summary = response.summary

    expect(summary).to be_kind_of(ChartMogul::Metrics::Summary)
    expect(summary.percentage_change).to_not be_nil
    expect(summary.previous).to_not be_nil
    expect(summary.current).to_not be_nil
  end

  it 'should have entries' do
    response = do_request
    expect(response.count).to_not be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    expect(entry.send(value_field)).to_not be_nil
  end
end

