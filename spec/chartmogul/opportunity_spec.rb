# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Opportunity do
  let(:attrs) do
    {
      uuid: uuid,
      customer_uuid: customer_uuid,
      owner: 'kamil+pavlicko@chartmogul.com',
      pipeline: 'New Business',
      pipeline_stage: 'Discovery',
      estimated_close_date: '2024-03-30',
      currency: 'USD',
      amount_in_cents: 100_000,
      type: 'one-time',
      forecast_category: 'best_case',
      win_likelihood: 30,
      custom: [{ key: 'from_campaign', value: true }]
    }
  end

  let(:uuid) { '3726cd86-e0f0-11ee-8d22-93b1d57bf35d' }
  let(:customer_uuid) { 'cus_8bae29d0-df51-11ee-88c8-97dc7855258a' }
  let(:updated_attributes) { { estimated_close_date: '2024-04-30' } }
  let(:cursor) { 'MjAyNC0wMy0xMVQwNjozODo0Ny44Nzk2NDYwMDBaJjAzZDdkNWJjLWRmNzItMTFlZS1iMTBkLThiNzg5ZDc1N2MyYQ==' }

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'sets the read-only properties correctly' do
      expect(subject).to have_attributes({ uuid: nil })
    end

    it 'sets the writeable properties correctly' do
      expect(subject).to have_attributes(attrs.reject { |k, _| k == :uuid })
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs)
    end
  end

  describe 'API Actions', uses_api: true, vcr: true do
    it 'retrieves all opportunities correctly' do
      opportunities = described_class.all(customer_uuid: customer_uuid)

      expect(opportunities.first).to have_attributes(
        uuid: uuid,
        customer_uuid: customer_uuid,
      )
      expect(opportunities.cursor).to eq(cursor)
      expect(opportunities.has_more).to eq(false)
    end

    it 'retrieves a opportunity correctly' do
      opportunity = described_class.retrieve(uuid)

      expect(opportunity).to have_attributes(
        uuid: uuid,
        customer_uuid: customer_uuid,
      )
    end

    it 'creates a opportunity correctly' do
      attributes = attrs.reject { |key, _| key == :uuid }
      opportunity = described_class.create!(**attributes)
      expect(opportunity).to have_attributes(**attributes.merge(custom: { from_campaign: true }))
    end

    it 'updates the opportunity correctly with the class method' do
      updated_opportunity = described_class.update!(
        uuid, **updated_attributes
      )

      expect(updated_opportunity).to have_attributes(
        uuid: uuid,
        customer_uuid: customer_uuid,
        **updated_attributes
      )
    end

    it 'destroys the opportunity correctly' do
      target_opportunity_uuid = '52115b0c-e54b-11ee-b769-a7d79ddfc0fb'
      deleted_opportunity = described_class.destroy!(uuid: target_opportunity_uuid)
      expect(deleted_opportunity).to eq(true)
    end

    context 'with old pagination' do
      let(:get_resources) { described_class.all(per_page: 1, page: 3) }

      it_behaves_like 'raises deprecated param error'
    end

    context 'with pagination' do
      let(:first_cursor) do
        'MjAyNC0wMy0xMVQwNzo0NTo0MS4xMzM4NjEwMDBaJjViZWUwYTQyLWRmN2ItMTFlZS05NTA2LWNiMjM4ZTliMTIxOA=='
      end
      let(:next_cursor) do
        'MjAyNC0wMy0xMVQwNjozODo0Ny44Nzk2NDYwMDBaJjAzZDdkNWJjLWRmNzItMTFlZS1iMTBkLThiNzg5ZDc1N2MyYQ=='
      end

      it 'paginates correctly' do
        opportunities = ChartMogul::Opportunity.all(per_page: 1)
        expect(opportunities).to have_attributes(
          cursor: first_cursor,
          has_more: true,
          size: 1
        )
        expect(opportunities.first).to have_attributes(
          uuid: '5bee0a42-df7b-11ee-9506-cb238e9b1218'
        )

        next_opportunities = opportunities.next(per_page: 1, customer_uuid: customer_uuid)
        expect(next_opportunities).to have_attributes(
          cursor: next_cursor,
          has_more: false,
          size: 1
        )
        expect(next_opportunities.first).to have_attributes(
          uuid: '03d7d5bc-df72-11ee-b10d-8b789d757c2a'
        )
      end
    end
  end
end
