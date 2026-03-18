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

    # Deletes all data from the data source (customers, invoices, subscriptions, etc.)
    # The data source itself remains.
    def empty!
      handling_errors do
        connection.delete("#{resource_path.path}/#{uuid}/all")
      end
      true
    end

    # Soft purges the data source, clearing it for reimport.
    # Optionally specify a new billing system to switch to.
    def soft_purge!(switch_system: nil)
      path = "#{resource_path.path}/#{uuid}/dependent"
      path += "?switch_system=#{CGI.escape(switch_system)}" if switch_system
      handling_errors do
        connection.delete(path)
      end
      true
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
