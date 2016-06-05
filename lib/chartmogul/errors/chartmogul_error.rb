module ChartMogul
  class ChartMogulError < StandardError
    attr_accessor :message
    attr_accessor :http_status

    def initialize(message, http_status:nil)
      @message = message
      @http_status = http_status
    end

    def to_s
      status = @http_status ? " (HTTP Status: #{@http_status.to_s})" : ''
      "#{message}#{status}"
    end
  end
end
