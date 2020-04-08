# frozen_string_literal: true

require_relative 'summary'

shared_examples 'Metrics API resource' do
  it_behaves_like 'Summary'

  it 'should have entries' do
    response = do_request
    expect(response.count).not_to be_nil

    entry = response[0]

    expect(entry).to be_kind_of(described_class)
    expect(entry.date).to be_kind_of(Date)
    expect(entry.send(value_field)).not_to be_nil
  end
end
