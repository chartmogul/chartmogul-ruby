# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Base < APIResource
        attr_reader :type, :data_source_uuid, :filename, :batch_name

        def initialize(data_source_uuid, filename, batch_name)
          @data_source_uuid = data_source_uuid
          @filename = filename
          @batch_name = batch_name
        end

        def send
          resp = handling_errors do
            connection.post(resource_path.apply(data_source_uuid: @data_source_uuid)) do |req|
              req.body = payload
            end
          end
          json = ChartMogul::Utils::JSONParser.parse(resp.body)
          ChartMogul::CSV::Uploads::Job.new_from_json(json)
        end

        private

        def payload
          {
            file: Faraday::FilePart.new(@filename, 'text/csv'),
            type: type,
            batch_name: @batch_name
          }
        end
      end
    end
  end
end
