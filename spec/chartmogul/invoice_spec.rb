# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Invoice do
  let(:json) do
    {
      date: '2016-01-01 12:00:00',
      currency: 'USD',
      disabled: false,
      disabled_at: nil,
      disabled_by: nil,
      edit_history_summary: {
        values_changed: {
          amount_in_cents: {
            original_value: 900,
            edited_value: 1000
          }
        },
        latest_edit_author: 'admin@example.com',
        latest_edit_performed_at: '2024-01-10T12:00:00.000Z'
      },
      errors: nil,
      line_items: [
        {
          type: 'subscription',
          subscription_external_id: 'sub_ext_id',
          subscription_set_external_id: 'set_ext_id',
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
          subscription_set_external_id: 'set_ext_id',
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
          uuid: 'li_1234-5678-9012-34567'
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
    }
  end

  let(:invoice_uuid) { 'inv_8ab74614-4e62-49f6-b4b3-f779109e50d0' }

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(
        currency: 'USD',
        date: '2016-01-01 12:00:00',
        due_date: '2016-02-01 12:00:00',
        external_id: 'inv_ext_id'
      )
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
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(json) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(
        uuid: 'inv_1234-5678-9012-34567',
        currency: 'USD',
        date: Time.parse('2016-01-01 12:00:00'),
        due_date: Time.parse('2016-02-01 12:00:00'),
        external_id: 'inv_ext_id'
      )
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
  end

  describe '#serialize_for_write' do
    subject { described_class.new(attrs) }

    it 'returns a valid hash' do
      expect(subject.serialize_for_write).to eq(
        date: '2016-01-01 12:00:00',
        currency: 'USD',
        line_items: [
          {
            type: 'subscription',
            subscription_external_id: 'sub_ext_id',
            subscription_set_external_id: 'set_ext_id',
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
      )
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves the invoice correctly' do
      invoice = described_class.retrieve(invoice_uuid)

      expect(invoice).to have_attributes(
        uuid: invoice_uuid,
        external_id: 'test_cus_inv_ext_id_1',
        currency: 'USD'
      )
    end

    it 'destroys the invoice correctly' do
      uuid_to_delete = 'inv_6fab6457-7b27-44c3-99ae-815923a22c7c'
      deleted_invoice = described_class.destroy!(uuid: uuid_to_delete)
      expect(deleted_invoice).to eq(true)
    end

    it 'destroys the invoice correctly with instance method' do
      invoice = described_class.retrieve('inv_c183cce8-a9f4-4992-b2d0-f42e16309866')
      deleted_invoice = invoice.destroy!
      expect(deleted_invoice).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 2) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyMy0xMC0zMFQwMzoxNjo1Ni4wMzUwMTcwMDBaJmludl82'\
        'ODk3ZDcwMC05OTNlLTQxYjUtYmVlNi1mMTU2OWM5MmNmMWU='
      end
      let(:next_cursor) do
        'MjAyMy0xMC0zMFQwMjo1ODo0MS4yNzkyNzIwMDBaJmludl84'\
        'YWI3NDYxNC00ZTYyLTQ5ZjYtYjRiMy1mNzc5MTA5ZTUwZDA='
      end

      it 'paginates correctly' do
        invoices = described_class.all(per_page: 1)
        expect(invoices).to have_attributes(
          cursor: first_cursor, has_more: true, size: 1
        )
        expect(invoices.first).to have_attributes(
          uuid: 'inv_6897d700-993e-41b5-bee6-f1569c92cf1e'
        )

        next_invoices = invoices.next(per_page: 1)
        expect(next_invoices).to have_attributes(
          cursor: next_cursor, has_more: true, size: 1
        )
        expect(next_invoices.first).to have_attributes(
          uuid: 'inv_8ab74614-4e62-49f6-b4b3-f779109e50d0'
        )
      end
    end

    context 'with validation_type query parameter' do
      it 'accepts validation_type=all in list', uses_api: false do
        allow(ChartMogul::Invoices).to receive(:connection).and_return(double('connection'))
        expect(ChartMogul::Invoices.connection).to receive(:get) do |path|
          expect(path).to eq('/v1/invoices?validation_type=all')
          double('response', body: '{"invoices": [], "cursor": null, "has_more": false}')
        end

        described_class.all(validation_type: 'all')
      end

      it_behaves_like 'retrieve with query params', 'inv_94d194de-04fa-4c81-8871-cc78af388eb3',
                      { validation_type: 'all' },
                      <<-JSON,
                      {
                        "uuid": "inv_94d194de-04fa-4c81-8871-cc78af388eb3",
                        "external_id": "test",
                        "currency": "USD",
                        "disabled": true,
                        "disabled_at": "2024-01-15T10:30:00.000Z",
                        "disabled_by": "user@example.com",
                        "edit_history_summary": {
                          "values_changed": {
                            "currency": {
                              "original_value": "EUR",
                              "edited_value": "USD"
                            },
                            "date": {
                              "original_value": "2024-01-01T00:00:00.000Z",
                              "edited_value": "2024-01-02T00:00:00.000Z"
                            }
                          },
                          "latest_edit_author": "editor@example.com",
                          "latest_edit_performed_at": "2024-01-20T15:45:00.000Z"
                        },
                        "errors": {
                          "currency": ["Currency is invalid", "Currency must be supported"],
                          "date": ["Date is in the future"]
                        }
                      }
                      JSON
                      lambda { |invoice|
                        expect(invoice.disabled).to eq(true)
                        expect(invoice.disabled_at).to eq('2024-01-15T10:30:00.000Z')
                        expect(invoice.disabled_by).to eq('user@example.com')
                        expect(invoice.edit_history_summary).to be_a(Hash)
                        expect(invoice.edit_history_summary[:values_changed]).to be_a(Hash)
                        expect(invoice.edit_history_summary[:values_changed][:currency][:original_value]).to eq('EUR')
                        expect(invoice.edit_history_summary[:values_changed][:currency][:edited_value]).to eq('USD')
                        expect(invoice.edit_history_summary[:latest_edit_author]).to eq('editor@example.com')
                        expect(invoice.edit_history_summary[:latest_edit_performed_at]).to eq('2024-01-20T15:45:00.000Z')
                        expect(invoice.errors).to be_a(Hash)
                        expect(invoice.errors[:currency]).to be_an(Array)
                        expect(invoice.errors[:currency].length).to eq(2)
                        expect(invoice.errors[:currency][0]).to eq('Currency is invalid')
                        expect(invoice.errors[:currency][1]).to eq('Currency must be supported')
                        expect(invoice.errors[:date]).to be_an(Array)
                        expect(invoice.errors[:date].length).to eq(1)
                        expect(invoice.errors[:date][0]).to eq('Date is in the future')
                      }
    end
  end
end
