# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::CustomerInvoices do
  let(:json) do
    {
      invoices: [
        {
          date: '2016-01-01 12:00:00',
          currency: 'USD',
          customer_external_id: 'ext-id',
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
          customer_external_id: 'ext-id',
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
              external_id: 'one_time_ext_id'
            ),
            ChartMogul::LineItems::OneTime.new(
              amount_in_cents: 1000,
              description: 'Dummy Description',
              quantity: 5,
              discount_amount_in_cents: 1200,
              discount_code: 'DISCCODE',
              tax_amount_in_cents: 200,
              external_id: 'one_time_ext_id'
            )
          ],
          transactions: [
            ChartMogul::Transactions::Payment.new(
              date: '2016-01-01 12:00:00',
              result: 'successful',
              external_id: 'pay_ext_id'
            ),
            ChartMogul::Transactions::Refund.new(
              date: '2016-01-01 12:00:00',
              result: 'successful',
              external_id: 'ref_ext_id'
            )
          ],
          external_id: 'inv_ext_id',
          due_date: '2016-02-01 12:00:00'
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
      expect(subject.invoices.first.customer_external_id).to eq('ext-id')
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
      expect(subject.invoices.first.customer_external_id).to eq('ext-id')
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
            customer_external_id: 'ext-id',
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

  describe 'API Actions', uses_api: true, vcr: true do
    it 'creates the customer invoice correctly' do
      data_source = ChartMogul::DataSource.retrieve('ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46')
      customer = ChartMogul::Customer.retrieve('cus_23551596-2c7e-11ee-9ea1-2bfe193640c0')
      plan = ChartMogul::Plan.retrieve('pl_de9e281e-76cb-11ee-b63f-b727630ce4d4')

      line_item = ChartMogul::LineItems::Subscription.new(
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
        external_id: 'test_cus_li_ext_id'
      )
      transaction = ChartMogul::Transactions::Payment.new(
        date: Time.utc(2016, 1, 1, 12),
        result: 'successful',
        external_id: 'test_cus_tr_ext_id'
      )
      invoice = ChartMogul::Invoice.new(
        date: Time.utc(2016, 1, 1, 12),
        currency: 'USD',
        external_id: 'test_cus_inv_ext_id_1',
        due_date: Time.utc(2016, 1, 7, 12),
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid
      )
      invoice.line_items << line_item
      invoice.transactions << transaction
      customer.invoices << invoice

      customer_invoices = customer.invoices.create!
      expect(customer_invoices.size).to eq(1)
      expect(customer_invoices[0].line_items.size).to eq(1)
      expect(customer_invoices[0].transactions.size).to eq(1)
    end

    context 'with handle_as_user_edit' do
      context 'when passed during initialization' do
        it 'sends handle_as_user_edit as query parameter', uses_api: false do
          customer_invoices = ChartMogul::CustomerInvoices.new(
            customer_uuid: 'cus_123',
            handle_as_user_edit: true,
            invoices: [
              ChartMogul::Invoice.new(
                date: '2016-01-01 12:00:00',
                currency: 'USD',
                external_id: 'inv_123'
              )
            ]
          )

          # Mock the connection to verify the URL includes the query parameter
          allow(ChartMogul::CustomerInvoices).to receive(:connection).and_return(double('connection'))
          expect(ChartMogul::CustomerInvoices.connection).to receive(:post) do |path, _body|
            expect(path).to include('handle_as_user_edit=true')
            double('response', body: '{}')
          end

          customer_invoices.create!
        end
      end

      context 'when passed as create params' do
        it 'sends handle_as_user_edit as query parameter', uses_api: false do
          # Mock the connection to verify the URL includes the query parameter
          allow(ChartMogul::CustomerInvoices).to receive(:connection).and_return(double('connection'))
          expect(ChartMogul::CustomerInvoices.connection).to receive(:post) do |path, _body|
            expect(path).to include('handle_as_user_edit=true')
            double('response', body: '{}')
          end

          ChartMogul::CustomerInvoices.create!(
            customer_uuid: 'cus_123',
            handle_as_user_edit: true,
            invoices: [
              ChartMogul::Invoice.new(
                date: '2016-01-01 12:00:00',
                currency: 'USD',
                external_id: 'inv_123'
              )
            ]
          )
        end
      end
    end

    describe 'update!' do
      context 'with handle_as_user_edit' do
        context 'when passed during initialization' do
          it 'sends handle_as_user_edit as query parameter', uses_api: false do
            customer_invoices = ChartMogul::CustomerInvoices.new(
              customer_uuid: 'cus_123',
              handle_as_user_edit: true,
              invoices: [
                ChartMogul::Invoice.new(
                  date: '2016-01-01 12:00:00',
                  currency: 'USD',
                  external_id: 'inv_123'
                )
              ]
            )

            # Mock the connection to verify the URL includes the query parameter
            allow(ChartMogul::CustomerInvoices).to receive(:connection).and_return(double('connection'))
            expect(ChartMogul::CustomerInvoices.connection).to receive(:put) do |path, _body|
              expect(path).to include('handle_as_user_edit=true')
              double('response', body: '{}')
            end

            customer_invoices.update!(invoices: [
              ChartMogul::Invoice.new(
                date: '2016-01-02 12:00:00',
                currency: 'USD',
                external_id: 'inv_124'
              )
            ])
          end
        end

        context 'when passed as update params' do
          it 'sends handle_as_user_edit as query parameter', uses_api: false do
            customer_invoices = ChartMogul::CustomerInvoices.new(
              customer_uuid: 'cus_123',
              invoices: [
                ChartMogul::Invoice.new(
                  date: '2016-01-01 12:00:00',
                  currency: 'USD',
                  external_id: 'inv_123'
                )
              ]
            )

            # Mock the connection to verify the URL includes the query parameter
            allow(ChartMogul::CustomerInvoices).to receive(:connection).and_return(double('connection'))
            expect(ChartMogul::CustomerInvoices.connection).to receive(:put) do |path, _body|
              expect(path).to include('handle_as_user_edit=true')
              double('response', body: '{}')
            end

            customer_invoices.update!(handle_as_user_edit: true, invoices: [
              ChartMogul::Invoice.new(
                date: '2016-01-02 12:00:00',
                currency: 'USD',
                external_id: 'inv_124'
              )
            ])
          end
        end
      end
    end

    it 'destroys all customer invoices correctly' do
      deleted_invoices = described_class.destroy_all!(
        'ds_03cfd2c4-2c7e-11ee-ab23-cb0f008cff46',
        'cus_23551596-2c7e-11ee-9ea1-2bfe193640c0'
      )
      expect(deleted_invoices).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) do
        described_class.all(
          'cus_23551596-2c7e-11ee-9ea1-2bfe193640c0',
          per_page: 1, page: 1
        )
      end

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:cursor) do
        'MjAyMy0xMC0zMFQwMjo1ODo0MS4yNzkyNzIwMDBaJmludl8'\
        '4YWI3NDYxNC00ZTYyLTQ5ZjYtYjRiMy1mNzc5MTA5ZTUwZDA='
      end

      it 'paginates correctly' do
        invoices = ChartMogul::CustomerInvoices.all(
          'cus_23551596-2c7e-11ee-9ea1-2bfe193640c0', per_page: 1
        )
        expect(invoices.size).to eq(1)
        expect(invoices).to have_attributes(
          cursor: cursor, current_page: 1,
          total_pages: 1, has_more: false
        )
        expect(invoices.first).to have_attributes(
          uuid: 'inv_8ab74614-4e62-49f6-b4b3-f779109e50d0'
        )

        next_invoices = invoices.next(per_page: 1)
        expect(next_invoices).to have_attributes(
          cursor: nil, has_more: false, size: 0
        )
      end
    end
  end
end
