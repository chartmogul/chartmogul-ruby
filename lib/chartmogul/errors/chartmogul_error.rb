module ChartMogul
  class ChartMogulError < StandardError
    attr_accessor :message
    attr_accessor :errors
    attr_accessor :http_status

    def initialize(message, http_status:nil, errors:nil)
      @message = message
      @http_status = http_status
      @errors = errors
    end

    def to_s
      status = @http_status ? " (HTTP Status: #{@http_status.to_s})" : ''
      errors = @errors ? "\nErrors: #{@errors.to_s}" : ''
      "#{message}#{status}#{errors}"
    end
  end
end
