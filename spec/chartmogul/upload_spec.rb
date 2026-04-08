# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Upload do
  describe '.new_from_json' do
    let(:json_attrs) do
      {
        id: 99,
        status: 'queued',
        created_at: '2026-03-17T10:00:00Z',
        updated_at: '2026-03-17T10:00:00Z',
        error_count: 0,
        processed_count: 0
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets all attributes correctly' do
      expect(subject).to have_attributes(
        id: 99,
        status: 'queued',
        error_count: 0,
        processed_count: 0
      )
    end
  end

  describe '.create!', uses_api: false do
    let(:tempfile) do
      file = Tempfile.new(['test', '.csv'])
      file.write("name,email\nTest,test@example.com\n")
      file.rewind
      file
    end

    after { tempfile.close! }

    before do
      # Stub the require so it doesn't fail when the gem is not installed
      allow(described_class).to receive(:require).with('faraday/multipart').and_return(true)
      # Define fake Faraday::Multipart module if not available
      unless defined?(Faraday::Multipart::FilePart)
        stub_const('Faraday::Multipart::FilePart', Class.new do
          def initialize(io, mime, filename); end
        end)
      end
    end

    it 'sends multipart POST to the correct path' do
      mock_connection = double('multipart_connection')
      allow(described_class).to receive(:multipart_connection).and_return(mock_connection)
      allow(described_class).to receive(:handling_errors).and_yield

      expect(mock_connection).to receive(:post) do |path, payload|
        expect(path).to eq('/v1/data_sources/ds_123/uploads')
        expect(payload[:type]).to eq('customers')
        expect(payload).to have_key(:file)
        double('response', body: '{"id": 99, "status": "queued"}')
      end

      result = described_class.create!(
        data_source_uuid: 'ds_123',
        file: tempfile,
        type: 'customers'
      )
      expect(result.id).to eq(99)
    end

    it 'includes batch_name when provided' do
      mock_connection = double('multipart_connection')
      allow(described_class).to receive(:multipart_connection).and_return(mock_connection)
      allow(described_class).to receive(:handling_errors).and_yield

      expect(mock_connection).to receive(:post) do |_path, payload|
        expect(payload[:batch_name]).to eq('my_batch')
        double('response', body: '{"id": 100, "status": "queued"}')
      end

      described_class.create!(
        data_source_uuid: 'ds_123',
        file: tempfile,
        type: 'customers',
        batch_name: 'my_batch'
      )
    end

    it 'accepts a file path string' do
      mock_connection = double('multipart_connection')
      allow(described_class).to receive(:multipart_connection).and_return(mock_connection)
      allow(described_class).to receive(:handling_errors).and_yield

      expect(mock_connection).to receive(:post) do |_path, payload|
        expect(payload).to have_key(:file)
        double('response', body: '{"id": 101, "status": "queued"}')
      end

      result = described_class.create!(
        data_source_uuid: 'ds_123',
        file: tempfile.path,
        type: 'invoices'
      )
      expect(result.id).to eq(101)
    end
  end
end
