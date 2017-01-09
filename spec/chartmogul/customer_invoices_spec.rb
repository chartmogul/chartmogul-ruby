require 'spec_helper'

describe ChartMogul::CustomerInvoices do
  let(:json) do
    {
      invoices: [
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
      ],
      customer_uuid: 'cus_1234-5678-9012-34567'
    }
  end

  let(:attrs) do
    {
      invoices: [
        ChartMogul::Invoice.new(
          date: '2016-01-01 12:00:00',
          currency: 'USD',
          line_items: [
            ChartMogul::Import::LineItems::Subscription.new(
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
            ),
            ChartMogul::Import::LineItems::OneTime.new(
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
          due_date: '2016-02-01 12:00:00',
        )
      ],
      customer_uuid: 'cus_1234-5678-9012-34567'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the invoices attribute' do
      expect(subject.invoices).to be_instance_of(Array)
      expect(subject.invoices.first).to be_instance_of(ChartMogul::Invoice)
    end

    it 'sets the customer_uuid attribute' do
      expect(subject.customer_uuid).to eq('cus_1234-5678-9012-34567')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(json) }

    it 'sets the invoices attribute' do
      expect(subject.invoices).to be_instance_of(Array)
      expect(subject.invoices.first).to be_instance_of(ChartMogul::Invoice)
    end

    it 'sets the customer_uuid attribute' do
      expect(subject.customer_uuid).to eq('cus_1234-5678-9012-34567')
    end
  end

  describe '#serialize_for_write' do
    subject { described_class.new(attrs) }

    it 'returns a valid hash' do
      expect(subject.serialize_for_write).to eq(
        invoices: [
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
                external_id: 'one_time_ext_id'
              },
              {
                type: 'one_time',
                amount_in_cents: 1000,
                description: 'Dummy Description',
                quantity: 5,
                discount_amount_in_cents: 1200,
                discount_code: 'DISCCODE',
                tax_amount_in_cents: 200,
                external_id: 'one_time_ext_id'
              }
            ],
            transactions: [
              {
                type: 'payment',
                date: '2016-01-01 12:00:00',
                result: 'successful',
                external_id: 'pay_ext_id'
              },
              {
                type: 'refund',
                date: '2016-01-01 12:00:00',
                result: 'successful',
                external_id: 'ref_ext_id'
              }
            ],
            external_id: 'inv_ext_id',
            due_date: '2016-02-01 12:00:00'
          }
        ],
        customer_uuid: 'cus_1234-5678-9012-34567'
      )
    end
  end

  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Customer Invoices Test Data Source'
      ).create!

      customer = ChartMogul::Customer.new(
        name: 'Test Customer', external_id: 'test_cus_ext_id',
        data_source_uuid: data_source.uuid, email: 'test@customer.com',
        city: 'Berlin', country: 'DE'
      ).create!

      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid, name: 'Test Plan',
        interval_count: 7, interval_unit: 'day', external_id: 'test_cus_pl_ext_id'
      ).create!

      line_item = ChartMogul::Import::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000,
        cancelled_at: Time.utc(2016, 1, 15, 12),
        prorated: false,
        quantity: 5,
        discount_amount_in_cents: 1200,
        discount_code: 'DISCCODE',
        tax_amount_in_cents: 200,
        external_id: 'test_cus_li_ext_id',
      )
      transaction = ChartMogul::Transactions::Payment.new(
        date: Time.utc(2016, 1, 1, 12),
        result: 'successful',
        external_id: 'test_cus_tr_ext_id',
      )
      invoice = ChartMogul::Invoice.new(
        date: Time.utc(2016, 1, 1, 12),
        currency: 'USD',
        external_id: 'test_cus_inv_ext_id',
        due_date: Time.utc(2016, 1, 7, 12)
      )
      invoice.line_items << line_item
      invoice.transactions << transaction

      customer.invoices << invoice
      customer.invoices.create!

      expect(customer.invoices[0].line_items.first.subscription_uuid).to eq(
        'sub_b39173f6-cd13-4c06-b6e6-0c659867439f'
      )

      data_source.destroy!
    end
  end
end
