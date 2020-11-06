# frozen_string_literal: true

module ChartMogul
  module CSV
    module Uploads
      class Base < APIResource
        attr_reader :type, :data_source_uuid, :data, :batch_name

        def initialize(data_source_uuid, batch_name)
          @data_source_uuid = data_source_uuid
          @batch_name = batch_name
        end

        def send(filename = nil, data = nil)
          resp = handling_errors do
            connection.post(resource_path.apply(data_source_uuid: @data_source_uuid)) do |req|
              req.body = payload(filename, data)
            end
          end
          json = ChartMogul::Utils::JSONParser.parse(resp.body)
          ChartMogul::CSV::Uploads::Job.new_from_json(json)
        end

        private

        def payload(filename, data)
          file = if filename.present?
                   Faraday::FilePart.new(filename, 'text/csv')
                 else
                   UploadIO.new(StringIO.new(data), 'text/csv')
                 end

          {
            file: file,
            type: type,
            batch_name: @batch_name
          }
        end
      end
    end
  end
end
