module ChartMogul
  class APIResource < ChartMogul::Object
    def self.connection
      @connection ||= Faraday.new(url: ChartMogul::API_BASE) do |faraday|
        faraday.use Faraday::Request::BasicAuthentication, ChartMogul.account_token, ChartMogul.secret_key
        faraday.use Faraday::Response::RaiseError
        faraday.use Faraday::Adapter::NetHttp
      end
    end

    def self.handling_errors
      yield
    rescue Faraday::ClientError => ex
      case ex.response[:status]
      when 403
      when 404
        message = "The requested #{self::NAME} could not be found."
        raise ChartMogul::NotFoundError.new(message, http_status: 404)
      when 422
        message = "The #{self::NAME} could not be created or updated."
        errors = JSON.parse(ex.response[:body], symbolize_names: true)[:errors]
        raise ChartMogul::ResourceInvalidError.new(message, http_status: 422, errors: errors)
      end
    rescue => ex
      raise ChartMogul::ChartMogulError.new(ex.message)
    end

    def handling_errors(&block)
      self.class.handling_errors(&block)
    end

    def connection
      self.class.connection
    end
  end
end
