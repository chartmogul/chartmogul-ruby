# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Utils::HashSnakeCaser do
  let(:hash) do
    {
      'key-key' => { 'withNestedHash' => true },
      'and-array' => [{}],
      :camelCasedKey => 'with string',
      :good_enough_key => 'here is nothing to do',
      :HUGE_SYMBOLS => 'wow'
    }
  end

  subject { described_class.new(hash) }

  it 'returns snake_cased keys' do
    expect(subject.to_snake_keys).to eq(
      'key_key' => { 'with_nested_hash' => true },
      'and_array' => [{}],
      :camel_cased_key => 'with string',
      :good_enough_key => 'here is nothing to do',
      :huge_symbols => 'wow'
    )
  end
end
