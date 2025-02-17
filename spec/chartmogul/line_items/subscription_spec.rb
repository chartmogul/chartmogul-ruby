# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::LineItems::Subscription do
  let(:attrs) do
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
      proration_type: nil,
      quantity: 5,
      discount_amount_in_cents: 1200,
      discount_code: 'DISCCODE',
      tax_amount_in_cents: 200,
      external_id: 'one_time_ext_id',
      transaction_fees_currency: 'EUR',
      discount_description: '2 EUR',
      uuid: 'li_1234-5678-9012-34567',
      subscription_uuid: 'sub_1234-5678-9012-34567',
      event_order: 5
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'doesnt set the subscription_uuid attribute' do
      expect(subject.subscription_uuid).to be_nil
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('subscription')
    end

    it 'sets the subscription_external_id attribute' do
      expect(subject.subscription_external_id).to eq('sub_ext_id')
    end

    it 'sets the subscription_set_external_id attribute' do
      expect(subject.subscription_set_external_id).to eq('set_ext_id')
    end

    it 'sets the plan_uuid attribute' do
      expect(subject.plan_uuid).to eq('pl_1234-5678-9012-34567')
    end

    it 'sets the service_period_start attribute' do
      expect(subject.service_period_start).to eq('2016-01-01 12:00:00')
    end

    it 'sets the service_period_end attribute' do
      expect(subject.service_period_end).to eq('2016-02-01 12:00:00')
    end

    it 'sets the amount_in_cents attribute' do
      expect(subject.amount_in_cents).to eq(1000)
    end

    it 'sets the cancelled_at attribute' do
      expect(subject.cancelled_at).to eq('2016-01-15 12:00:00')
    end

    it 'sets the prorated attribute' do
      expect(subject.prorated).to be_falsey
    end

    it 'sets the proration_type attribute' do
      expect(subject.proration_type).to be_nil
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

    it 'sets the discount_description attribute' do
      expect(subject.discount_description).to eq('2 EUR')
    end

    it 'sets the transaction_fees_currency attribute' do
      expect(subject.transaction_fees_currency).to eq('EUR')
    end

    it 'sets the event_order attribute' do
      expect(subject.event_order).to eq(5)
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('li_1234-5678-9012-34567')
    end

    it 'sets the subscription_uuid attribute' do
      expect(subject.subscription_uuid).to eq('sub_1234-5678-9012-34567')
    end

    it 'sets the type attribute' do
      expect(subject.type).to eq('subscription')
    end

    it 'sets the subscription_external_id attribute' do
      expect(subject.subscription_external_id).to eq('sub_ext_id')
    end

    it 'sets the subscription_set_external_id attribute' do
      expect(subject.subscription_set_external_id).to eq('set_ext_id')
    end

    it 'sets the plan_uuid attribute' do
      expect(subject.plan_uuid).to eq('pl_1234-5678-9012-34567')
    end

    it 'sets the service_period_start attribute' do
      expect(subject.service_period_start).to eq(Time.parse('2016-01-01 12:00:00'))
    end

    it 'sets the service_period_end attribute' do
      expect(subject.service_period_end).to eq(Time.parse('2016-02-01 12:00:00'))
    end

    it 'sets the amount_in_cents attribute' do
      expect(subject.amount_in_cents).to eq(1000)
    end

    it 'sets the cancelled_at attribute' do
      expect(subject.cancelled_at).to eq(Time.parse('2016-01-15 12:00:00'))
    end

    it 'sets the prorated attribute' do
      expect(subject.prorated).to be_falsey
    end

    it 'sets the proration_type attribute' do
      expect(subject.proration_type).to be_nil
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
