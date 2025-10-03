# frozen_string_literal: true

module ChartMogul
  module CSV
    module LineItems
      class UsageBased < Subscription
        def type
          'usage_based'
        end
      end
    end
  end
end
