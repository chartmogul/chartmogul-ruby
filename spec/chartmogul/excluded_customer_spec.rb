# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::ExcludedCustomer do
  let(:customer_uuid) { 'cus_7e8f9a0b-c62a-11f1-9a3e-2b8c4f0d1e2a' }
  let(:attrs) do
    {
      customer_uuid: customer_uuid,
      data_source_uuid: 'ds_1a2b3c4d-c62a-11f1-9a3e-2b8c4f0d1e2a',
      external_id: 'ext-1',
      name: 'Acme',
      email: 'acme@example.com',
      excluded_at: '2026-11-20T10:00:00.000Z'
    }
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(attrs.merge(excluded_at: Time.utc(2026, 11, 20, 10)))
    end
  end

  describe 'API Actions', uses_api: true do
    let(:base_url) { "#{ChartMogul.api_base}/v1/excluded_customers" }

    around { |example| VCR.turned_off { example.run } }

    describe '.all' do
      before do
        stub_request(:get, base_url)
          .with(query: { cursor: 'cursor-1', per_page: '2' })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: { entries: [attrs], cursor: 'cursor-2', has_more: true }.to_json
          )
      end

      it 'passes the pagination params and parses entries and the cursor' do
        excluded_customers = described_class.all(cursor: 'cursor-1', per_page: 2)

        expect(excluded_customers).to be_a(ChartMogul::ExcludedCustomers)
        expect(excluded_customers.size).to eq(1)
        expect(excluded_customers.first).to have_attributes(customer_uuid: customer_uuid, external_id: 'ext-1')
        expect(excluded_customers).to have_attributes(cursor: 'cursor-2', has_more: true)
      end

      it 'fetches the next page with the returned cursor' do
        stub_request(:get, base_url)
          .with(query: { cursor: 'cursor-2', per_page: '2' })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: { entries: [], cursor: nil, has_more: false }.to_json
          )

        next_page = described_class.all(cursor: 'cursor-1', per_page: 2).next(per_page: 2)

        expect(next_page).to have_attributes(size: 0, has_more: false)
      end
    end

    describe 'reinclude!' do
      before do
        stub_request(:delete, "#{base_url}/#{customer_uuid}")
          .to_return(
            status: 202,
            headers: { 'Content-Type' => 'application/json' },
            body: { customer_uuid: customer_uuid, status: 'reimporting' }.to_json
          )
      end

      it 'returns the re-import status from the class method' do
        expect(described_class.reinclude!(customer_uuid))
          .to have_attributes(customer_uuid: customer_uuid, status: 'reimporting')
      end

      it 'returns the re-import status from the instance method' do
        excluded_customer = described_class.new_from_json(attrs)

        expect(excluded_customer.reinclude!).to have_attributes(customer_uuid: customer_uuid, status: 'reimporting')
      end

      it 'raises NotFoundError when the customer is not excluded' do
        stub_request(:delete, "#{base_url}/cus_missing")
          .to_return(status: 404, body: '{"error":"Not found"}', headers: { 'Content-Type' => 'application/json' })

        expect { described_class.reinclude!('cus_missing') }.to raise_error(ChartMogul::NotFoundError)
      end
    end
  end
end
