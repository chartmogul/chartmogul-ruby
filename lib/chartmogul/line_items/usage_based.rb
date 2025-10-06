# frozen_string_literal: true

module ChartMogul
  module LineItems
    class UsageBased < Subscription
      def initialize(attributes = {})
        super(attributes)
        @type = 'usage_based'
      end
    end
  end
end
