# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Account, uses_api: true do
  describe 'API interactions', vcr: true, record: :all do
    let(:account) { ChartMogul::Account.retrieve }

    it 'returns the name of current account', uses_api: true do
      expect(account.name).to eq('Example Test Company')
    end

    it 'returns the currency of current account', uses_api: true do
      expect(account.currency).to eq('EUR')
    end

    it 'returns the time zone of current account', uses_api: true do
      expect(account.time_zone).to eq('Europe/Berlin')
    end

    it 'returns the week_start_on of current account', uses_api: true do
      expect(account.week_start_on).to eq('sunday')
    end
  end
end
