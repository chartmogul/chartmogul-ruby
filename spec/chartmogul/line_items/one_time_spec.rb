# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::LineItems::OneTime do
  ATTRS = {
    type: 'one_time',
    amount_in_cents: 1000,
    description: 'Dummy Description',
    quantity: 5,
    discount_amount_in_cents: 1200,
    discount_code: 'DISCCODE',
    tax_amount_in_cents: 200,
    external_id: 'one_time_ext_id',
    uuid: 'li_1234-5678-9012-34567',
    plan_uuid: 'pl_1234-5678-9012-34567',
    transaction_fees_currency: 'EUR',
    discount_description: '2 EUR',
    event_order: 5
  }.freeze

  describe '#initialize' do
    subject { described_class.new(ATTRS) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    ATTRS.each do |key, value|
      next if key == :uuid

      it "sets the #{key} attribute" do
        expect(subject.public_send(key)).to eq value
      end
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(ATTRS) }

    ATTRS.each do |key, value|
      it "sets the #{key} attribute" do
        expect(subject.public_send(key)).to eq value
      end
    end
  end
end
