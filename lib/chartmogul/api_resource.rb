# frozen_string_literal: true

require 'forwardable'

module ChartMogul
  class APIResource < ChartMogul::Object
    extend Forwardable

    RETRY_STATUSES = [429, *500..599].freeze
    RETRY_EXCEPTIONS = [
      'Faraday::ConnectionFailed',
      'Faraday::RetriableResponse'
    ].freeze
    BACKOFF_FACTOR = 2
    INTERVAL_RANDOMNESS = 0.5
    INTERVAL = 1
    MAX_INTERVAL = 60
    THREAD_CONNECTION_KEY = 'chartmogul_ruby.api_resource.connection'

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

    def self.immutable_keys
      @immutable_keys ||= []
    end

    # When set with keys, nested hash keys of these immutable keys won't be converted to snake case
    def self.set_immutable_keys(array)
      @immutable_keys = array
    end

    def self.connection
      Thread.current[THREAD_CONNECTION_KEY] ||= build_connection
    end

    def self.handling_errors
      yield
    rescue Faraday::ClientError, Faraday::ServerError => e
      e.response ? handle_request_error(e) : handle_other_error(e)
    rescue StandardError => e
      handle_other_error(e)
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
        message = 'The requested action is forbidden.'
        raise ChartMogul::ForbiddenError.new(message, http_status: 403, response: response)
      when 404
        message = "The requested #{resource_name} could not be found."
        raise ChartMogul::NotFoundError.new(message, http_status: 404, response: response)
      when 422
        message = "The #{resource_name} could not be created or updated."
        raise ChartMogul::ResourceInvalidError.new(message, http_status: 422, response: response)
      when 500..504
        message = 'ChartMogul API server response error'
        raise ChartMogul::ServerError.new(message, http_status: http_status, response: response)
      else
        message = "#{resource_name} request error has occurred."
        raise ChartMogul::ChartMogulError.new(message, http_status: http_status, response: response)
      end
    end

    def self.handle_other_error(exception)
      raise ChartMogul::ChartMogulError, exception.message
    end

    def_delegators 'self.class', :resource_path, :resource_name, :resource_root_key, :connection, :handling_errors

    private

    def self.build_connection
      Faraday.new(url: ChartMogul.api_base) do |faraday|
        faraday.use Faraday::Request::BasicAuthentication, ChartMogul.api_key, ''
        faraday.use Faraday::Response::RaiseError
        faraday.request :retry, max: ChartMogul.max_retries, retry_statuses: RETRY_STATUSES,
                                max_interval: MAX_INTERVAL, backoff_factor: BACKOFF_FACTOR,
                                interval_randomness: INTERVAL_RANDOMNESS, interval: INTERVAL, exceptions: RETRY_EXCEPTIONS
        faraday.adapter Faraday::Adapter::NetHttp
      end
    end
  end
end
