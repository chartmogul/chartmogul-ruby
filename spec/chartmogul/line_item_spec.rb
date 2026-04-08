# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::LineItem do
  describe '.new_from_json' do
    let(:json_attrs) do
      {
        uuid: 'li_abc-123',
        type: 'subscription',
        amount_in_cents: 5000,
        external_id: 'li_ext_1',
        data_source_uuid: 'ds_123',
        invoice_uuid: 'inv_123',
        disabled: false,
        disabled_at: nil,
        disabled_by: nil,
        errors: { service_period_start: ['is required'] },
        edit_history_summary: { latest_edit_author: 'admin@example.com' }
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets readonly attributes correctly' do
      expect(subject).to have_attributes(
        uuid: 'li_abc-123',
        invoice_uuid: 'inv_123',
        disabled: false,
        errors: { service_period_start: ['is required'] },
        edit_history_summary: { latest_edit_author: 'admin@example.com' }
      )
    end
  end

  describe 'API methods', uses_api: false do
    describe '.create!' do
      it 'sends POST to the correct path' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:post) do |path, &block|
          expect(path).to eq('/v1/import/invoices/inv_123/line_items')
          double('response', body: '{"uuid": "li_new", "type": "subscription", "amount_in_cents": 1000}')
        end

        result = described_class.create!(invoice_uuid: 'inv_123', type: 'subscription', amount_in_cents: 1000)
        expect(result.uuid).to eq('li_new')
      end

      it 'includes handle_as_user_edit as query parameter' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:post) do |path, &_block|
          expect(path).to include('handle_as_user_edit=true')
          double('response', body: '{"uuid": "li_new"}')
        end

        described_class.create!(invoice_uuid: 'inv_123', handle_as_user_edit: true, type: 'subscription')
      end
    end

    describe '.retrieve_by_external_id' do
      it 'sends GET with correct query params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:get) do |path|
          expect(path).to eq('/v1/line_items?data_source_uuid=ds_123&external_id=li_ext_1')
          double('response', body: '{"uuid": "li_abc", "external_id": "li_ext_1"}')
        end

        result = described_class.retrieve_by_external_id(data_source_uuid: 'ds_123', external_id: 'li_ext_1')
        expect(result.uuid).to eq('li_abc')
      end
    end

    describe '.update_by_external_id!' do
      it 'sends PATCH with correct query params and body' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to eq('/v1/line_items?data_source_uuid=ds_123&external_id=li_ext_1')
          double('response', body: '{"uuid": "li_abc", "amount_in_cents": 2000}')
        end

        result = described_class.update_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'li_ext_1', amount_in_cents: 2000
        )
        expect(result.amount_in_cents).to eq(2000)
      end

      it 'includes handle_as_user_edit as query parameter' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to include('handle_as_user_edit=true')
          double('response', body: '{}')
        end

        described_class.update_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'li_ext_1',
          handle_as_user_edit: true, amount_in_cents: 2000
        )
      end
    end

    describe '.destroy_by_external_id!' do
      it 'sends DELETE with correct query params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:delete) do |path|
          expect(path).to eq('/v1/line_items?data_source_uuid=ds_123&external_id=li_ext_1')
          double('response', body: '', status: 204)
        end

        result = described_class.destroy_by_external_id!(data_source_uuid: 'ds_123', external_id: 'li_ext_1')
        expect(result).to eq(true)
      end
    end

    describe '#toggle_disabled!' do
      it 'sends PATCH to disabled_state path' do
        line_item = described_class.new_from_json(uuid: 'li_abc', type: 'subscription', amount_in_cents: 1000)

        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to eq('/v1/line_items/li_abc/disabled_state')
          double('response', body: '{"uuid": "li_abc", "disabled": true, "disabled_at": "2026-03-17T10:00:00Z"}')
        end

        line_item.toggle_disabled!(disabled: true)
        expect(line_item.disabled).to eq(true)
      end

      it 'includes handle_as_user_edit as query parameter' do
        line_item = described_class.new_from_json(uuid: 'li_abc', type: 'subscription', amount_in_cents: 1000)

        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to include('handle_as_user_edit=true')
          double('response', body: '{"uuid": "li_abc", "disabled": true}')
        end

        line_item.toggle_disabled!(disabled: true, handle_as_user_edit: true)
      end
    end

    describe '.toggle_disabled_by_external_id!' do
      it 'sends PATCH to disabled_state path with external_id params' do
        allow(described_class).to receive(:connection).and_return(double('connection'))
        expect(described_class.connection).to receive(:patch) do |path, &_block|
          expect(path).to start_with('/v1/line_items/disabled_state?')
          expect(path).to include('data_source_uuid=ds_123')
          expect(path).to include('external_id=li_ext_1')
          double('response', body: '{"uuid": "li_abc", "disabled": false}')
        end

        result = described_class.toggle_disabled_by_external_id!(
          data_source_uuid: 'ds_123', external_id: 'li_ext_1', disabled: false
        )
        expect(result.disabled).to eq(false)
      end
    end
  end
end
