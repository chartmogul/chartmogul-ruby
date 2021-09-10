# frozen_string_literal: true

module ChartMogul
  class Account < APIResource
    set_resource_name 'Account'
    set_resource_path '/v1/account'

    readonly_attr :name
    readonly_attr :currency
    readonly_attr :time_zone
    readonly_attr :week_start_on

    include API::Actions::Custom

    def self.retrieve
      custom!(:get, '/v1/account')
    end
  end
end
