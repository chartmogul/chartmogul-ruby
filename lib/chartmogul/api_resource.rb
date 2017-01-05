require 'forwardable'

module ChartMogul
  class APIResource < ChartMogul::Object
    extend Forwardable

    class << self; attr_reader :resource_path, :resource_name, :resource_root_key end

    def self.set_resource_path(path)
      @resource_path = ChartMogul::ResourcePath.new(path)
    end

    def self.set_resource_name(name)
      @resource_name = name
    end

    def self.set_resource_root_key(root_key)
      @resource_root_key = root_key
    end

    def self.connection
      @connection ||= Faraday.new(url: ChartMogul::API_BASE) do |faraday|
        faraday.use Faraday::Request::BasicAuthentication, ChartMogul.account_token, ChartMogul.secret_key
        faraday.use Faraday::Response::RaiseError
        faraday.use Faraday::Adapter::NetHttp
      end
    end

    def self.handling_errors
      yield
    rescue Faraday::ClientError => exception
      exception.response ? handle_request_error(exception) : handle_other_error(exception)
    rescue => exception
      handle_other_error(exception)
    end

    def self.handle_request_error(exception)
      response = exception.response[:body]
      http_status = exception.response[:status]
      case http_status
      when 400
        message = "JSON schema validation hasn't passed."
        raise ChartMogul::SchemaInvalidError.new(message, http_status: 400, response: response)
      when 401
        message = 'No valid API key provided'
        raise ChartMogul::UnauthorizedError.new(message, http_status: 401, response: response)
      when 403
        message = "The requested action is forbidden."
        raise ChartMogul::ForbiddenError.new(message, http_status: 403, response: response)
      when 404
        message = "The requested #{resource_name} could not be found."
        raise ChartMogul::NotFoundError.new(message, http_status: 404, response: response)
      when 422
        message = "The #{resource_name} could not be created or updated."
        raise ChartMogul::ResourceInvalidError.new(message, http_status: 422, response: response)
      else
        message = "#{resource_name} request error has occurred."
        raise ChartMogul::ChartMogulError.new(message, http_status: http_status, response: response)
      end
    end

    def self.handle_other_error(exception)
      raise ChartMogul::ChartMogulError.new(exception.message)
    end

    def_delegators 'self.class', :resource_path, :resource_name, :resource_root_key, :connection, :handling_errors
  end
end
