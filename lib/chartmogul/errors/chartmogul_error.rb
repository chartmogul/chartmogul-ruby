# frozen_string_literal: true

module ChartMogul
  class ChartMogulError < StandardError
    attr_reader :error_message, :response, :http_status

    def initialize(error_message, http_status: nil, response: nil)
      @error_message = error_message
      @http_status = http_status
      @response = response

      super(build_message)
    end

    def build_message
      status = http_status ? " (HTTP Status: #{http_status})" : ''
      resp = response ? "\nResponse: #{response}" : ''
      "#{error_message}#{status}#{resp}"
    end
  end
end
