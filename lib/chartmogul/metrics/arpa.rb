# frozen_string_literal: true

module ChartMogul
  module Metrics
    class ARPA < ChartMogul::Object
      readonly_attr :date, type: :date
      readonly_attr :arpa
      readonly_attr :percentage_change
    end

    class ARPAs < APIResource
      set_resource_name 'ARPAs'
      set_resource_path '/v1/metrics/arpa'

      include Concerns::Entries
      include Concerns::Summary

      set_entry_class ARPA
    end
  end
end
