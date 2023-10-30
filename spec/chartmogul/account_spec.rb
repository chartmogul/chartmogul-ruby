# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Account, uses_api: true do
  describe 'API interactions' do
    around(:all) do |example|
      VCR.use_cassette('ChartMogul_Account/returns_details_of_current_account', &example)
    end

    let(:account) { ChartMogul::Account.retrieve }

    it 'returns the right account attributes' do
      expect(account).to have_attributes(
        name: 'Example Test Company',
        currency: 'EUR',
        time_zone: 'Europe/Berlin',
        week_start_on: 'sunday'
      )
    end
  end
end
