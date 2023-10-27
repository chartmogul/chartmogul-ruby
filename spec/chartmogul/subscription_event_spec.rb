# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::SubscriptionEvent do
  describe 'API interactions', vcr: true do
    it 'lists all subscription events', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Events Test ds_index'
      ).create!
      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!
      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!
      subscription = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      single_event = ChartMogul::SubscriptionEvent.new(
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid,
        effective_date: '2021-12-30T00:01:00Z',
        event_date: '2022-05-18T09:48:34Z',
        event_type: 'subscription_cancelled',
        external_id: 'test_ev_id_create_1',
        subscription_external_id: subscription.subscription_external_id,
        subscription_set_external_id: '',
        plan_external_id: '',
        currency: '',
        amount_in_cents: '',
        quantity: ''
      ).create!

      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events.size).to eq 1
      expect(events[0].id).to eq single_event.id
      expect(events.meta[:total_pages]).to eq(1)
      expect(events.cursor).to eq('MjAyMy0xMC0yN1QwODoxNTozNy4yMzE0NjMwMDBaJjM3NDI3Nzc0Ng==')
      expect(events.has_more).to eq(false)

      single_event.destroy!
      data_source.destroy!
    end

    it 'creates a new subscription event through initialization', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Events Test ds_create'
      ).create!
      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!
      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!
      subscription = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      single_event = ChartMogul::SubscriptionEvent.new(
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid,
        effective_date: '2021-12-30T00:01:00Z',
        event_date: '2022-05-18T09:48:34Z',
        event_type: 'subscription_cancelled',
        external_id: 'test_ev_id_create_1',
        subscription_external_id: subscription.subscription_external_id,
        subscription_set_external_id: '',
        plan_external_id: '',
        currency: '',
        amount_in_cents: '',
        quantity: ''
      ).create!

      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events[0].id).to eq single_event.id

      single_event.destroy!
      data_source.destroy!
    end

    it 'creates a new subscription event', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Events Test ds_create'
      ).create!
      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!
      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!
      subscription = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      single_event = ChartMogul::SubscriptionEvent.create!(
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid,
        effective_date: '2021-12-30T00:01:00Z',
        event_date: '2022-05-18T09:48:34Z',
        event_type: 'subscription_cancelled',
        external_id: 'test_ev_id_create_1',
        subscription_external_id: subscription.subscription_external_id,
        subscription_set_external_id: '',
        plan_external_id: '',
        currency: '',
        amount_in_cents: '',
        quantity: ''
      )

      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events[0].id).to eq single_event.id

      single_event.destroy!
      data_source.destroy!
    end

    it 'updates the subscription event', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Events Test ds_update'
      ).create!
      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!
      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!
      subscription = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      single_event = ChartMogul::SubscriptionEvent.new(
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid,
        effective_date: '2021-12-30T00:01:00Z',
        event_date: '2022-05-18T09:48:34Z',
        event_type: 'subscription_cancelled',
        external_id: 'test_ev_id_update_1',
        subscription_external_id: subscription.subscription_external_id,
        subscription_set_external_id: '',
        plan_external_id: '',
        currency: '',
        amount_in_cents: '',
        quantity: ''
      ).create!

      single_event.update!(external_id: 'test_ev_id_update_2')

      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events.size).to eq 1
      expect(events[0].external_id).to eq 'test_ev_id_update_2'

      single_event.destroy!
      data_source.destroy!
    end

    it 'deletes the subscription event', uses_api: true do
      data_source = ChartMogul::DataSource.new(
        name: 'Subscription Events Test ds_destroy'
      ).create!
      customer = ChartMogul::Customer.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Customer',
        external_id: 'test_cus_ext_id'
      ).create!
      plan = ChartMogul::Plan.new(
        data_source_uuid: data_source.uuid,
        name: 'Test Plan1',
        interval_count: 7,
        interval_unit: 'day'
      ).create!
      subscription = ChartMogul::LineItems::Subscription.new(
        subscription_external_id: 'test_cus_sub_ext_id1',
        plan_uuid: plan.uuid,
        service_period_start: Time.utc(2016, 1, 1, 12),
        service_period_end: Time.utc(2016, 2, 1, 12),
        amount_in_cents: 1000
      )
      single_event = ChartMogul::SubscriptionEvent.new(
        customer_external_id: customer.external_id,
        data_source_uuid: data_source.uuid,
        effective_date: '2021-12-30T00:01:00Z',
        event_date: '2022-05-18T09:48:34Z',
        event_type: 'subscription_cancelled',
        external_id: 'test_ev_id_delete_1',
        subscription_external_id: subscription.subscription_external_id,
        subscription_set_external_id: '',
        plan_external_id: '',
        currency: '',
        amount_in_cents: '',
        quantity: ''
      ).create!

      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events.size).to eq 1

      single_event.destroy!
      events = described_class.all(data_source_uuid: data_source.uuid)

      expect(events.size).to eq 0

      data_source.destroy!
    end

    it 'should paginate using cursor when called with #next', uses_api: true do
      customer_uuid = 'cus_713e32ae-74a1-11ee-b822-fbc804fece75'

      events = described_class.all(customer_uuid: customer_uuid, per_page: 1)
      expect(events.size).to eq(1)
      expect(events[0].id).to eq(374279754)

      next_events = events.next(customer_uuid: customer_uuid, per_page: 1)
      expect(next_events.size).to eq(1)
      expect(next_events[0].id).to eq(374279751)
    end
  end
end
