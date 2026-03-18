# frozen_string_literal: true

module ChartMogul
  # Upload resource for uploading CSV files to a data source.
  # Note: Requires the 'faraday-multipart' gem for file uploads.
  class Upload < APIResource
    set_resource_name 'Upload'
    set_resource_path '/v1/data_sources/:data_source_uuid/uploads'

    readonly_attr :id
    readonly_attr :status
    readonly_attr :created_at
    readonly_attr :updated_at
    readonly_attr :error_count
    readonly_attr :processed_count

    # Upload a CSV file to a data source
    # @param data_source_uuid [String] The UUID of the data source
    # @param file [File, String] File object or path to the CSV file
    # @param type [String] The type of data being uploaded (e.g., 'customers', 'invoices')
    # @param batch_name [String, nil] Optional name for the upload batch
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def self.create!(data_source_uuid:, file:, type:, batch_name: nil)
      require 'faraday/multipart'

      path = "/v1/data_sources/#{data_source_uuid}/uploads"
      file_io, filename = prepare_file(file)
      payload = build_payload(file_io, filename, type, batch_name)

      resp = handling_errors do
        multipart_connection.post(path, payload)
      end

      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    ensure
      file_io&.close if file.is_a?(String) && file_io
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def self.prepare_file(file)
      file_io = file.is_a?(String) ? File.open(file, 'rb') : file
      filename = file.is_a?(String) ? File.basename(file) : extract_filename(file)
      [file_io, filename]
    end
    private_class_method :prepare_file

    def self.extract_filename(file)
      file.respond_to?(:path) ? File.basename(file.path) : 'upload.csv'
    end
    private_class_method :extract_filename

    def self.build_payload(file_io, filename, type, batch_name)
      payload = {
        file: Faraday::Multipart::FilePart.new(file_io, 'text/csv', filename),
        type:
      }
      payload[:batch_name] = batch_name if batch_name
      payload
    end
    private_class_method :build_payload

    def self.multipart_connection
      Faraday.new(url: ChartMogul.api_base,
        headers: { 'User-Agent' => "chartmogul-ruby/#{ChartMogul::VERSION}" }) do |f|
        f.use Faraday::Response::RaiseError
        f.request :authorization, :basic, ChartMogul.api_key, ''
        f.request :multipart
        f.request :retry, max: ChartMogul.max_retries, retry_statuses: RETRY_STATUSES,
          max_interval: MAX_INTERVAL, backoff_factor: BACKOFF_FACTOR,
          interval_randomness: INTERVAL_RANDOMNESS, interval: INTERVAL, exceptions: RETRY_EXCEPTIONS
        f.adapter Faraday::Adapter::NetHttp
      end
    end
    private_class_method :multipart_connection
  end
end
