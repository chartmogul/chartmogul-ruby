require 'spec_helper'

describe ChartMogul::Import::Transactions::Payment do
  let(:attrs) do
    {
      type: 'payment',
      date: '2016-01-01 12:00:00',
      result: 'successful',
      external_id: 'pay_ext_id',
      uuid: 'tr_1234-5678-9012-34567'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('payment')
    end

    it 'sets the date attribute' do
      expect(subject.date).to eq('2016-01-01 12:00:00')
    end

    it 'sets the result attribute' do
      expect(subject.result).to eq('successful')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('pay_ext_id')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }
    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('tr_1234-5678-9012-34567')
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('payment')
    end

    it 'sets the date attribute' do
      expect(subject.date).to eq(Time.parse '2016-01-01 12:00:00')
    end

    it 'sets the result attribute' do
      expect(subject.result).to eq('successful')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('pay_ext_id')
    end
  end

  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Invoice Payment Test Data Source'
      ).create!

      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!

      line_item = ChartMogul::Import::LineItems::OneTime.new(
        amount_in_cents: 1000
      )
      invoice = ChartMogul::Invoice.new(
        external_id: 'test_tr_inv_ext_id',
        date: Time.utc(2016, 1, 1, 12),
        currency: 'USD',
        line_items: [line_item]
      )
      ChartMogul::CustomerInvoices.new(
        customer_uuid: customer.uuid,
        invoices: [invoice]
      ).create!

      transaction = ChartMogul::Import::Transactions::Payment.new(
        date: Time.utc(2016, 1, 1, 12),
        result: 'successful',
        external_id: 'test_tr_ext_id',
        invoice_uuid: invoice.uuid
      ).create!

      expect(transaction.uuid).to be

      data_source.destroy!
    end
  end
end
