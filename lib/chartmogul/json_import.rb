# frozen_string_literal: true

module ChartMogul
  # JsonImport resource for bulk importing data via JSON.
  # Use this to efficiently upload large datasets to a data source.
  class JsonImport < APIResource
    set_resource_name 'JsonImport'
    set_resource_path '/v1/data_sources/:data_source_uuid/json_imports'

    readonly_attr :id
    readonly_attr :external_id
    readonly_attr :status
    readonly_attr :created_at
    readonly_attr :updated_at
    readonly_attr :error_count
    readonly_attr :processed_count

    # Create a new JSON import batch for a data source
    # @param data_source_uuid [String] The UUID of the data source
    # @param data [Hash] The import data (customers, plans, invoices, etc.)
    def self.create!(data_source_uuid:, **data)
      path = "/v1/data_sources/#{data_source_uuid}/json_imports"
      resp = handling_errors do
        connection.post(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(data)
        end
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end

    # Retrieve the status of a JSON import
    # @param data_source_uuid [String] The UUID of the data source
    # @param id [String, Integer] The ID of the import
    def self.retrieve(data_source_uuid:, id:)
      path = "/v1/data_sources/#{data_source_uuid}/json_imports/#{id}"
      resp = handling_errors do
        connection.get(path)
      end
      json = ChartMogul::Utils::JSONParser.parse(resp.body, immutable_keys:)
      new_from_json(json)
    end
  end
end
