# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Transaction do
  describe '.new_from_json' do
    let(:json_attrs) do
      {
        uuid: 'tr_abc-123',
        type: 'payment',
        date: '2026-01-15T12:00:00Z',
        result: 'successful',
        external_id: 'tr_ext_1',
        invoice_uuid: 'inv_123',
        disabled: false,
        errors: { date: ['is in the future'] },
        edit_history_summary: { latest_edit_author: 'admin@example.com' }
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets readonly attributes correctly' do
      expect(subject).to have_attributes(
        uuid: 'tr_abc-123',
        invoice_uuid: 'inv_123',
        disabled: false,
        errors: { date: ['is in the future'] },
        edit_history_summary: { latest_edit_author: 'admin@example.com' }
      )
    end
  end

  describe 'API methods', uses_api: false do
    describe '.retrieve_by_external_id' do
      it 'sends GET with correct query params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:get) do |path|
          expect(path).to eq('/v1/transactions?data_source_uuid=ds_123&external_id=tr_ext_1')
          double('response', body: '{"uuid": "tr_abc", "external_id": "tr_ext_1"}')
        end

        result = described_class.retrieve_by_external_id(data_source_uuid: 'ds_123', external_id: 'tr_ext_1')
        expect(result.uuid).to eq('tr_abc')
      end
    end

    describe '.update_by_external_id!' do
      it 'sends PATCH with correct query params and body' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to eq('/v1/transactions?data_source_uuid=ds_123&external_id=tr_ext_1')
          double('response', body: '{"uuid": "tr_abc", "result": "failed"}')
        end

        result = described_class.update_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'tr_ext_1', result: 'failed'
        )
        expect(result.result).to eq('failed')
      end

      it 'includes handle_as_user_edit as query parameter' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to include('handle_as_user_edit=true')
          double('response', body: '{}')
        end

        described_class.update_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'tr_ext_1',
          handle_as_user_edit: true, result: 'failed'
        )
      end
    end

    describe '.destroy_by_external_id!' do
      it 'sends DELETE with correct query params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:delete) do |path|
          expect(path).to eq('/v1/transactions?data_source_uuid=ds_123&external_id=tr_ext_1')
          double('response', body: '', status: 204)
        end

        result = described_class.destroy_by_external_id!(data_source_uuid: 'ds_123', external_id: 'tr_ext_1')
        expect(result).to eq(true)
      end
    end

    describe '#toggle_disabled!' do
      it 'sends PATCH to disabled_state path' do
        txn = described_class.new_from_json(uuid: 'tr_abc', type: 'payment', date: '2026-01-15T12:00:00Z', result: 'successful')

        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to eq('/v1/transactions/tr_abc/disabled_state')
          double('response', body: '{"uuid": "tr_abc", "disabled": true, "disabled_at": "2026-03-17T10:00:00Z"}')
        end

        txn.toggle_disabled!(disabled: true)
        expect(txn.disabled).to eq(true)
      end
    end

    describe '.toggle_disabled_by_external_id!' do
      it 'sends PATCH to disabled_state path with external_id params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to start_with('/v1/transactions/disabled_state?')
          expect(path).to include('data_source_uuid=ds_123')
          expect(path).to include('external_id=tr_ext_1')
          double('response', body: '{"uuid": "tr_abc", "disabled": false}')
        end

        result = described_class.toggle_disabled_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'tr_ext_1', disabled: false
        )
        expect(result.disabled).to eq(false)
      end
    end
  end
end
