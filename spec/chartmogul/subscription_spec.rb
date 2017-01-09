require 'spec_helper'

describe ChartMogul::Subscription do
  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Test Data Source'
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

      line_item = ChartMogul::Import::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id',
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

      customer.subscriptions.first.cancel(Time.utc(2016, 1, 15, 12))

      expect(customer.subscriptions.first.cancellation_dates).to match_array(
        [Time.utc(2016, 01,15, 12)]
      )

      data_source.destroy!
    end
  end
end
