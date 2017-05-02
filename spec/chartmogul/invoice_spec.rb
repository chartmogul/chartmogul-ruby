require 'spec_helper'

describe ChartMogul::Invoice do
  let(:json) do
    {
      date: '2016-01-01 12:00:00',
      currency: 'USD',
      line_items: [
        {
          type: 'subscription',
          subscription_external_id: 'sub_ext_id',
          plan_uuid: 'pl_1234-5678-9012-34567',
          service_period_start: '2016-01-01 12:00:00',
          service_period_end: '2016-02-01 12:00:00',
          amount_in_cents: 1000,
          cancelled_at: '2016-01-15 12:00:00',
          prorated: false,
          quantity: 5,
          discount_amount_in_cents: 1200,
          discount_code: 'DISCCODE',
          tax_amount_in_cents: 200,
          external_id: 'one_time_ext_id',
          uuid: 'li_1234-5678-9012-34567',
          subscription_uuid: 'sub_1234-5678-9012-34567'
        },
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
      ],
      transactions: [
        {
          type: 'payment',
          date: '2016-01-01 12:00:00',
          result: 'successful',
          external_id: 'pay_ext_id',
          uuid: 'tr_1234-5678-9012-34567'
        },
        {
          type: 'refund',
          date: '2016-01-01 12:00:00',
          result: 'successful',
          external_id: 'ref_ext_id',
          uuid: 'tr_1234-5678-9012-34567'
        }
      ],
      external_id: 'inv_ext_id',
      due_date: '2016-02-01 12:00:00',
      uuid: 'inv_1234-5678-9012-34567'
    }
  end

  let(:attrs) do
    {
      date: '2016-01-01 12:00:00',
      currency: 'USD',
      line_items: [
        ChartMogul::LineItems::Subscription.new(
          subscription_external_id: 'sub_ext_id',
          plan_uuid: 'pl_1234-5678-9012-34567',
          service_period_start: '2016-01-01 12:00:00',
          service_period_end: '2016-02-01 12:00:00',
          amount_in_cents: 1000,
          cancelled_at: '2016-01-15 12:00:00',
          prorated: false,
          quantity: 5,
          discount_amount_in_cents: 1200,
          discount_code: 'DISCCODE',
          tax_amount_in_cents: 200,
          external_id: 'one_time_ext_id',
          uuid: 'li_1234-5678-9012-34567',
        ),
        ChartMogul::LineItems::OneTime.new(
          amount_in_cents: 1000,
          description: 'Dummy Description',
          quantity: 5,
          discount_amount_in_cents: 1200,
          discount_code: 'DISCCODE',
          tax_amount_in_cents: 200,
          external_id: 'one_time_ext_id',
        )
      ],
      transactions: [
        ChartMogul::Transactions::Payment.new(
          date: '2016-01-01 12:00:00',
          result: 'successful',
          external_id: 'pay_ext_id',
        ),
        ChartMogul::Transactions::Refund.new(
          date: '2016-01-01 12:00:00',
          result: 'successful',
          external_id: 'ref_ext_id',
        )
      ],
      external_id: 'inv_ext_id',
      due_date: '2016-02-01 12:00:00'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the date attribute' do
      expect(subject.date).to eq('2016-01-01 12:00:00')
    end

    it 'sets the currency attribute' do
      expect(subject.currency).to eq('USD')
    end

    it 'sets the line_items attribute' do
      expect(subject.line_items).to be_instance_of(Array)
      expect(subject.line_items.first).to be_instance_of(ChartMogul::LineItems::Subscription)
      expect(subject.line_items.last).to be_instance_of(ChartMogul::LineItems::OneTime)
    end

    it 'sets the transactions attribute' do
      expect(subject.transactions).to be_instance_of(Array)
      expect(subject.transactions.first).to be_instance_of(ChartMogul::Transactions::Payment)
      expect(subject.transactions.last).to be_instance_of(ChartMogul::Transactions::Refund)
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('inv_ext_id')
    end

    it 'sets the due_date attribute' do
      expect(subject.due_date).to eq('2016-02-01 12:00:00')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(json) }

    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('inv_1234-5678-9012-34567')
    end

    it 'sets the date attribute' do
      expect(subject.date).to eq(Time.parse '2016-01-01 12:00:00')
    end

    it 'sets the currency attribute' do
      expect(subject.currency).to eq('USD')
    end

    it 'sets the line_items attribute' do
      expect(subject.line_items).to be_instance_of(Array)
      expect(subject.line_items.first).to be_instance_of(ChartMogul::LineItems::Subscription)
      expect(subject.line_items.last).to be_instance_of(ChartMogul::LineItems::OneTime)
    end

    it 'sets the transactions attribute' do
      expect(subject.transactions).to be_instance_of(Array)
      expect(subject.transactions.first).to be_instance_of(ChartMogul::Transactions::Payment)
      expect(subject.transactions.last).to be_instance_of(ChartMogul::Transactions::Refund)
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('inv_ext_id')
    end

    it 'sets the due_date attribute' do
      expect(subject.due_date).to eq(Time.parse '2016-02-01 12:00:00')
    end
  end

  describe '#serialize_for_write' do
    subject { described_class.new(attrs) }

    it 'returns a valid hash' do
      expect(subject.serialize_for_write).to eq(
        date: "2016-01-01 12:00:00",
        currency: "USD",
        line_items: [
          {
            type: "subscription",
            subscription_external_id: "sub_ext_id",
            plan_uuid: "pl_1234-5678-9012-34567",
            service_period_start: "2016-01-01 12:00:00",
            service_period_end: "2016-02-01 12:00:00",
            amount_in_cents: 1000,
            cancelled_at: "2016-01-15 12:00:00",
            prorated: false,
            quantity: 5,
            discount_amount_in_cents: 1200,
            discount_code: "DISCCODE",
            tax_amount_in_cents: 200,
            external_id: "one_time_ext_id"
          },
          {
            type: "one_time",
            amount_in_cents: 1000,
            description: "Dummy Description",
            quantity: 5,
            discount_amount_in_cents: 1200,
            discount_code: "DISCCODE",
            tax_amount_in_cents: 200,
            external_id: "one_time_ext_id"
          }
        ],
        transactions: [
          {
            type: "payment",
            date: "2016-01-01 12:00:00",
            result: "successful",
            external_id: "pay_ext_id"
          },
          {
            type: "refund",
            date: "2016-01-01 12:00:00",
            result: "successful",
            external_id: "ref_ext_id"
          }
        ],
        external_id: "inv_ext_id",
        due_date: "2016-02-01 12:00:00"
      )
    end
  end
  describe 'API Interactions', vcr: true do
    it 'returns all invoices through list all endpoint', uses_api: true do
      invoices = described_class.all(per_page: 10, external_id: "invoice_eid")
      expect(invoices.instance_of? ChartMogul::Invoices).to be true
      expect(invoices.size).to eq 1
      expect(invoices[0].instance_of? described_class).to be true
      expect(invoices[0].external_id).to eq "invoice_eid"
      expect(invoices[0].customer_uuid).to eq "customer_uuid"
    end
  end
end
