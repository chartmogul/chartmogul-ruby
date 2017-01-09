require 'spec_helper'

describe ChartMogul::Transactions::Refund do
  let(:attrs) do
    {
      type: 'refund',
      date: '2016-01-01 12:00:00',
      result: 'successful',
      external_id: 'ref_ext_id',
      uuid: 'tr_1234-5678-9012-34567'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('refund')
    end

    it 'sets the date attribute' do
      expect(subject.date).to eq('2016-01-01 12:00:00')
    end

    it 'sets the result attribute' do
      expect(subject.result).to eq('successful')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('ref_ext_id')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }
    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('tr_1234-5678-9012-34567')
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('refund')
    end

    it 'sets the date attribute' do
      expect(subject.date).to eq(Time.parse '2016-01-01 12:00:00')
    end

    it 'sets the result attribute' do
      expect(subject.result).to eq('successful')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('ref_ext_id')
    end
  end
end
