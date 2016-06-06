module ChartMogul
  module Import
    class Customer < APIResource
      NAME = 'Customer'
      RESOURCE_PATH = '/v1/import/customers'
      ROOT_KEY = :customers

      writeable_attr :data_source_uuid
      writeable_attr :external_id
      writeable_attr :name
      writeable_attr :email
      writeable_attr :company
      writeable_attr :country
      writeable_attr :state
      writeable_attr :city
      writeable_attr :zip

      readonly_attr :uuid

      include API::Actions::All
      include API::Actions::Create
      include API::Actions::Destroy
    end
  end
end
