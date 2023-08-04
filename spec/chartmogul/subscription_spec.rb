# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Subscription do
  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Test Data api_sub'
      ).create!

      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!

      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan',
        interval_count: 7,
        interval_unit: 'day'
      ).create!

      line_item = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id',
        subscription_set_external_id: 'test_cus_set_ext_id',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
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

      expect(customer.subscriptions.size).to eq(1)
      expect(customer.subscriptions.first.uuid).to eq('sub_14dc8bc6-d647-4347-94ca-e30a91af8d78')
      expect(customer.subscriptions.first.data_source_uuid).to eq('ds_0c08bbd2-5298-11ee-bc33-d32b6a5410f4')
      expect(customer.subscriptions.first.external_id).to eq('test_cus_sub_ext_id')
      expect(customer.subscriptions.first.subscription_set_external_id).to eq('test_cus_set_ext_id')
      expect(customer.subscriptions.has_more).to eq(false)

      customer.subscriptions.first.cancel(Time.utc(2016, 1, 15, 12))

      expect(customer.subscriptions.first.cancellation_dates).to match_array(
        [Time.utc(2016, 1, 15, 12)]
      )

      data_source.destroy!
    end

    it 'has multiple aliases', uses_api: true do
      subscriptions = described_class.all('cus_521ffa10-5296-11ee-ad49-1f952cc8bc4f', per_page: 2)
      expect(subscriptions.has_more).to eq(false)
      expect(subscriptions.size).to eq(1)
      expect(subscriptions.first.uuid).to eq('sub_093e376f-c0a3-4fbf-9638-a7f2892652ee')

      subscriptions = ChartMogul::Subscriptions.all('cus_521ffa10-5296-11ee-ad49-1f952cc8bc4f', per_page: 1)
      expect(subscriptions.has_more).to eq(false)
      expect(subscriptions.size).to eq(1)
      expect(subscriptions.first.uuid).to eq('sub_093e376f-c0a3-4fbf-9638-a7f2892652ee')
    end

    it 'connects subscriptions', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Test Data Source api_connect'
      ).create!

      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!

      plan1 = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!

      plan2 = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan2',
        interval_count: 7,
        interval_unit: 'day'
      ).create!

      line_item1 = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan1.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      line_item2 = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id2',
        plan_uuid: plan2.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      invoice1 = ChartMogul::Invoice.new(
        external_id: 'test_tr_inv_ext_id1',
        date: Time.utc(2016, 1, 1, 12),
        currency: 'USD',
        line_items: [line_item1]
      )
      invoice2 = ChartMogul::Invoice.new(
        external_id: 'test_tr_inv_ext_id2',
        date: Time.utc(2016, 1, 1, 12),
        currency: 'USD',
        line_items: [line_item2]
      )
      ChartMogul::CustomerInvoices.new(
        customer_uuid: customer.uuid,
        invoices: [invoice1, invoice2]
      ).create!

      expect(customer.subscriptions.size).to eq(2)
      expect(customer.subscriptions[0].external_id).to eq('test_cus_sub_ext_id2')
      expect(customer.subscriptions[1].external_id).to eq('test_cus_sub_ext_id1')
      expect(customer.subscriptions.has_more).to eq(false)

      customer.subscriptions.first.cancel(Time.utc(2016, 1, 15, 12))

      expect(customer.subscriptions.first.cancellation_dates).to match_array(
        [Time.utc(2016, 1, 15, 12)]
      )

      customer.subscriptions.first.connect(customer.uuid, customer.subscriptions[1..-1])
      subs = ChartMogul::Metrics::Customers::Subscription.all(customer.uuid)
      expect(subs.count).to eq(1)
      sub = subs[0]
      expect(sub.external_id).to eq('test_cus_sub_ext_id1')
      data_source.destroy!
    end
  end

  describe '#update_cancellation_dates', uses_api: true, vcr: true do
    let(:external_id) { 'test_cus_ext_id' }
    let(:customer) { ChartMogul::Customer.all(external_id: external_id).first }
    let(:subscription) { customer.subscriptions.first }

    subject { subscription.update_cancellation_dates(dates) }

    before { WebMock.allow_net_connect! }

    describe 'when array is empty' do
      let(:dates) { [] }

      it 'makes an API call and removes the cancellation dates' do
        expect(subject.cancellation_dates).to eq []
      end
    end

    describe 'when array includes invalid entries' do
      let(:dates) { ['invalid_entry'] }

      it 'raises an exception' do
        expect { subject }. to raise_error(ArgumentError, 'no time information in "invalid_entry"')
      end
    end

    describe 'when array includes valid entries' do
      let(:dates) { ['2000-01-01'] }

      it 'is setting the cancellation dates of the subscription' do
        expect(subject.cancellation_dates).to eq [Time.utc(1999, 12, 31, 22)]
      end
    end

    describe 'when array has time objects' do
      let(:dates) { [Time.utc(2000, 1, 1)] }

      it 'is setting the cancellation dates of the subscription' do
        expect(subject.cancellation_dates).to eq [Time.utc(2000, 1, 1)]
      end
    end
  end
end
