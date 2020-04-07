# frozen_string_literal: true

require 'uri'

module ChartMogul
  class ResourcePath
    attr_reader :path
    attr_reader :named_params

    class RequiredParameterMissing < StandardError; end

    def initialize(path)
      @path = path
      @named_params = path.scan(/:\w+/).each_with_object({}) do |named_param, hash|
        hash[named_param] = named_param.delete(':').to_sym
      end
    end

    def apply(params = {})
      apply_named_params(params)
    end

    # For path = '/hello/:hello_id/say' & params = { hello_id: 1, search: 'cat' }
    # it will return '/hello/1/say?search=cat'

    def apply_with_get_params(params = {})
      base_path = apply_named_params(params)
      get_params = params.reject { |param_name| named_params.values.include?(param_name) }

      get_params.empty? ? base_path : "#{base_path}?#{URI.encode_www_form(get_params)}"
    end

    private

    def apply_named_params(params)
      path.dup.tap do |path|
        named_params.each do |named_param, param_key|
          unless params.key?(param_key)
            raise(RequiredParameterMissing, "#{named_param} is required")
          end

          path.gsub!(named_param, params[param_key].to_s)
        end
      end
    end
  end
end
