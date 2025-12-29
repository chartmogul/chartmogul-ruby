# frozen_string_literal: true

module ChartMogul
  class DataSource < APIResource
    set_resource_name 'Data Source'
    set_resource_path '/v1/data_sources'

    readonly_attr :uuid
    readonly_attr :status
    readonly_attr :system
    readonly_attr :created_at, type: :time
    readonly_attr :invoice_handling_setting

    writeable_attr :name

    include API::Actions::All
    include API::Actions::Create
    include API::Actions::Custom
    include API::Actions::Destroy
    include API::Actions::Retrieve
    include Concerns::AutoChurnSubscriptionSetting
    include Concerns::ProcessingStatus

    def self.all(options = {})
      DataSources.all(options)
    end
  end

  class DataSources < APIResource
    set_resource_name 'Data Sources'
    set_resource_path '/v1/data_sources'

    set_resource_root_key :data_sources

    include Concerns::Entries

    set_entry_class DataSource
  end
end
