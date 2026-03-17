# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::JsonImport do
  describe '.new_from_json' do
    let(:json_attrs) do
      {
        id: 42,
        external_id: 'import_ext_1',
        status: 'pending',
        created_at: '2026-03-17T10:00:00Z',
        updated_at: '2026-03-17T10:00:00Z',
        error_count: 0,
        processed_count: 100
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets all attributes correctly' do
      expect(subject).to have_attributes(
        id: 42,
        external_id: 'import_ext_1',
        status: 'pending',
        error_count: 0,
        processed_count: 100
      )
    end
  end

  describe 'API methods', uses_api: false do
    describe '.create!' do
      it 'sends POST to the correct path with JSON body' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:post) do |path, &_block|
          expect(path).to eq('/v1/data_sources/ds_123/json_imports')
          double('response', body: '{"id": 42, "status": "pending"}')
        end

        result = described_class.create!(
          data_source_uuid: 'ds_123',
          customers: [{ external_id: 'cust_1', name: 'Test' }]
        )
        expect(result.id).to eq(42)
        expect(result.status).to eq('pending')
      end
    end

    describe '.retrieve' do
      it 'sends GET to the correct path' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:get) do |path|
          expect(path).to eq('/v1/data_sources/ds_123/json_imports/42')
          double('response', body: '{"id": 42, "status": "completed", "processed_count": 50, "error_count": 2}')
        end

        result = described_class.retrieve(data_source_uuid: 'ds_123', id: 42)
        expect(result).to have_attributes(
          id: 42,
          status: 'completed',
          processed_count: 50,
          error_count: 2
        )
      end
    end
  end
end
