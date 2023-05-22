# frozen_string_literal: true

module ChartMogul
  module CSV
    class Customer < Base
      CUSTOMER_HEADERS = %w[Name Email Company Country State City Zip External\ ID Lead\ created\ at Free\ trial\ started\ at Attributes].freeze

      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/03_Invoices.csv
      writeable_attr :name
      writeable_attr :email
      writeable_attr :description
      writeable_attr :country_id
      writeable_attr :state_id
      writeable_attr :city
      writeable_attr :address_zip
      writeable_attr :external_id
      writeable_attr :lead_created_at
      writeable_attr :free_trial_started_at
      writeable_attr :attributes

      def self.headers
        CUSTOMER_HEADERS
      end
    end
  end
end
