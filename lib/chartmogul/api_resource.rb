# frozen_string_literal: true

require "forwardable"
require "set"

module ChartMogul
  class APIResource < ChartMogul::Object
    extend Forwardable

    RETRY_STATUSES = [429, *500..599].freeze
    RETRY_EXCEPTIONS = [
      "Faraday::ConnectionFailed",
      "Faraday::RetriableResponse"
    ].freeze
    BACKOFF_FACTOR = 2
    INTERVAL_RANDOMNESS = 0.5
    INTERVAL = 1
    MAX_INTERVAL = 60
    THREAD_CONNECTION_KEY = "chartmogul_ruby.api_resource.connection"

    class << self; attr_reader :resource_path, :resource_name, :resource_root_key end

    def self.query_params
      @query_params ||= Set.new
    end

    def self.writeable_query_param(attribute, options = {})
      query_params << attribute.to_sym
      writeable_attr(attribute, options)
    end

    def self.extract_query_params(attrs, resource_key = nil)
      remaining_attrs = attrs.dup
      query_params = {}

      self.query_params.each do |param|
        # If resource_key is specified, look in nested structure
        if resource_key && remaining_attrs[resource_key].is_a?(Hash) &&
           remaining_attrs[resource_key]&.key?(param) &&
           remaining_attrs[resource_key][param]
          query_params[param] = remaining_attrs[resource_key].delete(param)
        # Otherwise look at top level
        elsif !resource_key && remaining_attrs.key?(param) && remaining_attrs[param]
          query_params[param] = remaining_attrs.delete(param)
        end
      end

      [remaining_attrs, query_params]
    end

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
        message = "No valid API key provided"
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
      when 500..504
        message = "ChartMogul API server response error"
        raise ChartMogul::ServerError.new(message, http_status: http_status, response: response)
      else
        message = "#{resource_name} request error has occurred."
        raise ChartMogul::ChartMogulError.new(message, http_status: http_status, response: response)
      end
    end

    def self.handle_other_error(exception)
      raise ChartMogul::ChartMogulError, exception.message
    end

    def_delegators "self.class", :resource_path, :resource_name, :resource_root_key, :connection, :handling_errors

    def extract_query_params(attrs, resource_key = nil)
      remaining_attrs = attrs.dup
      query_params = {}

      self.class.query_params.each do |param|
        next unless resource_key && remaining_attrs[resource_key].is_a?(Hash) &&
                    remaining_attrs[resource_key]&.key?(param) &&
                    remaining_attrs[resource_key][param]

        query_params[param] = remaining_attrs[resource_key].delete(param)
      end

      [remaining_attrs, query_params]
    end

    # Generate path with query parameters applied
    def path_with_query_params(attrs)
      _, query_params = extract_query_params(attrs)
      query_params.empty? ? resource_path.path : resource_path.apply_with_get_params(query_params)
    end

    # Enhanced custom! that automatically handles query parameters
    def custom_with_query_params!(http_method, body_data = {}, resource_key = nil)
      attrs, query_params = extract_query_params(body_data, resource_key)
      # Only include path parameters from instance attributes, plus extracted query parameters
      path_params = instance_attributes.select { |key, _| resource_path.named_params.values.include?(key) }
      path_and_query_params = path_params.merge(query_params)
      path = resource_path.apply_with_get_params(path_and_query_params)

      custom!(http_method, path, attrs)
    end

    # Class method version for enhanced custom! with query parameters
    def self.custom_with_query_params!(http_method, body_data = {}, resource_key = nil)
      attrs, query_params = extract_query_params(body_data, resource_key)
      # Only include path parameters from body data, plus extracted query parameters
      path_params = body_data.select { |key, _| resource_path.named_params.values.include?(key) }
      path_and_query_params = path_params.merge(query_params)
      path = resource_path.apply_with_get_params(path_and_query_params)

      custom!(http_method, path, attrs)
    end

    def self.build_connection
      Faraday.new(url: ChartMogul.api_base,
        headers: { "User-Agent" => "chartmogul-ruby/#{ChartMogul::VERSION}" }) do |faraday|
        faraday.use Faraday::Response::RaiseError
        faraday.request :authorization, :basic, ChartMogul.api_key, ""
        faraday.request :retry, max: ChartMogul.max_retries, retry_statuses: RETRY_STATUSES,
          max_interval: MAX_INTERVAL, backoff_factor: BACKOFF_FACTOR,
          interval_randomness: INTERVAL_RANDOMNESS, interval: INTERVAL, exceptions: RETRY_EXCEPTIONS
        faraday.adapter Faraday::Adapter::NetHttp
      end
    end
  end
end
