# frozen_string_literal: true

module ChartMogul
  module Metrics
    class ASP < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :asp
    end

    class ASPs < APIResource
      set_resource_name 'ASPs'
      set_resource_path '/v1/metrics/asp'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class ASP
    end
  end
end
