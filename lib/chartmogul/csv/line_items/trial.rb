# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      # from https://chartmogul-samples.s3-eu-west-1.amazonaws.com/public/04_Invoice_line_items.csv
      SUBSCRIPTION_HEADERS = ['Invoice external ID', 'External ID', 'Subscription external ID',
                              'Subscription set external ID', 'Type', 'Amount in cents', 'Plan', 'Service period start', 'Service period end', 'Quantity', 'Proration', 'Discount code', 'Discount amount', 'Tax amount', 'Description', 'Transaction fee', 'Account Code', 'Transaction fees currency', 'Discount description', 'Proration type', 'Event Order'].freeze

      class Trial < Subscription
      end
    end
  end
end
