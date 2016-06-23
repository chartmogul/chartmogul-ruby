module ChartMogul
  class ChartMogulError < StandardError
    attr_accessor :message
    attr_accessor :response
    attr_accessor :http_status

    def initialize(message, http_status:nil, response:nil)
      @message = message
      @http_status = http_status
      @response = response
    end

    def to_s
      status = @http_status ? " (HTTP Status: #{@http_status.to_s})" : ''
      response = @response ? "\nResponse: #{@response.to_s}" : ''
      "#{message}#{status}#{response}"
    end
  end
end
