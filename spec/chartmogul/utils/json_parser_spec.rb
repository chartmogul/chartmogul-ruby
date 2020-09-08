# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Utils::JSONParser do
  describe '::typecast_custom_attributes' do
    it 'parses ISO 8601, returned by ChartMogul API' do
      result = described_class.typecast_custom_attributes(attr: '2016-02-01T00:00:00.000Z')
      expect(result[:attr]).to be_instance_of(Time)
    end

    it 'parses RFC 2822' do
      result = described_class.typecast_custom_attributes(attr: 'Fri, 30 Aug 2019 12:13:07 +0000')
      expect(result[:attr]).to be_instance_of(Time)
    end

    it 'doesn\'t parse string vaguely looking like a date' do
      result = described_class.typecast_custom_attributes(attr: 'May the force be with you.')
      expect(result[:attr]).to be_instance_of(String)
    end

    it 'return string if parse of timestamp failed' do
      result = described_class.typecast_custom_attributes(attr: '2016-02-01T0000:00.000Z')
      expect(result[:attr]).to be_instance_of(String)
    end

    it 'allows skipping camel case conversion' do
      json = {'aKey': 'a_value', 'bKey': 'b_value'}.to_json
      result = described_class.parse(json, skip_case_conversion: true)
      expect(result.keys).to contain_exactly(:aKey,:bKey)
    end
  end
end
