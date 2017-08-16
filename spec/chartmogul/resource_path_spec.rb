require 'spec_helper'

describe ChartMogul::ResourcePath do
  context 'without named params' do
    subject { described_class.new('/my_custom/url') }

    describe '#apply' do
      it 'returns rigth path if no parameters passed' do
        expect(subject.apply).to eq('/my_custom/url')
      end

      it 'returns rigth path if parameters passed' do
        expect(subject.apply(custom: 1)).to eq('/my_custom/url')
      end
    end

    describe '#apply_with_get_params' do
      it 'returns rigth path without GET params if no parameters passed' do
        expect(subject.apply_with_get_params).to eq('/my_custom/url')
      end

      it 'returns rigth path with GET params if parameters passed' do
        expect(subject.apply_with_get_params(custom: 1)).to eq('/my_custom/url?custom=1')
      end
    end
  end

  context 'with named params' do
    subject { described_class.new('/my_custom/:custom/url') }

    describe '#apply' do
      it 'returns rigth path if only named parameter passed' do
        expect(subject.apply(custom: 123)).to eq('/my_custom/123/url')
      end

      it 'returns rigth path if additional parameters passed' do
        expect(subject.apply(custom: 123, example: 456)).to eq('/my_custom/123/url')
      end

      it 'raises an exception if named parameter not passed' do
        expect { subject.apply }.to raise_error(
          ChartMogul::ResourcePath::RequiredParameterMissing, ':custom is required'
        )
      end
    end

    describe '#apply_with_get_params' do
      it 'returns rigth path without GET params if no additional parameters passed' do
        expect(subject.apply_with_get_params(custom: 123)).to eq('/my_custom/123/url')
      end

      it 'returns rigth path with GET params if additional parameters passed' do
        expect(subject.apply_with_get_params(custom: 123, example: 456)).to eq(
          '/my_custom/123/url?example=456'
        )
      end

      it 'raises an exception if named parameter not passed' do
        expect { subject.apply_with_get_params }.to raise_error(
          ChartMogul::ResourcePath::RequiredParameterMissing, ':custom is required'
        )
      end
    end
  end
end
