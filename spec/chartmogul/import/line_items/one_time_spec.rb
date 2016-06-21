require 'spec_helper'

describe ChartMogul::Import::LineItems::OneTime do
  let(:attrs) do
    {
      type: 'one_time',
      amount_in_cents: 1000,
      description: 'Dummy Description',
      quantity: 5,
      discount_amount_in_cents: 1200,
      discount_code: 'DISCCODE',
      tax_amount_in_cents: 200,
      external_id: 'one_time_ext_id',
      uuid: 'li_1234-5678-9012-34567'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('one_time')
    end

    it 'sets the amount_in_cents attribute' do
      expect(subject.amount_in_cents).to eq(1000)
    end

    it 'sets the description attribute' do
      expect(subject.description).to eq('Dummy Description')
    end

    it 'sets the quantity attribute' do
      expect(subject.quantity).to eq(5)
    end

    it 'sets the discount_amount_in_cents attribute' do
      expect(subject.discount_amount_in_cents).to eq(1200)
    end

    it 'sets the discount_code attribute' do
      expect(subject.discount_code).to eq('DISCCODE')
    end

    it 'sets the tax_amount_in_cents attribute' do
      expect(subject.tax_amount_in_cents).to eq(200)
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('one_time_ext_id')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('li_1234-5678-9012-34567')
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('one_time')
    end

    it 'sets the amount_in_cents attribute' do
      expect(subject.amount_in_cents).to eq(1000)
    end

    it 'sets the description attribute' do
      expect(subject.description).to eq('Dummy Description')
    end

    it 'sets the quantity attribute' do
      expect(subject.quantity).to eq(5)
    end

    it 'sets the discount_amount_in_cents attribute' do
      expect(subject.discount_amount_in_cents).to eq(1200)
    end

    it 'sets the discount_code attribute' do
      expect(subject.discount_code).to eq('DISCCODE')
    end

    it 'sets the tax_amount_in_cents attribute' do
      expect(subject.tax_amount_in_cents).to eq(200)
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('one_time_ext_id')
    end
  end
end
