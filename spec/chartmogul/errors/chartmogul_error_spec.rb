# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::ChartMogulError do
  let(:message) { 'This is a test error' }

  subject { ChartMogul::ChartMogulError.new(message, http_status: http_status) }

  context 'when a HTTP status is supplied' do
    let(:http_status) { 404 }

    it 'generates the correct error message' do
      expect(subject.to_s).to eq('This is a test error (HTTP Status: 404)')
    end
  end

  context 'when a HTTP status is not supplied' do
    let(:http_status) { nil }

    it 'generates the correct error message' do
      expect(subject.to_s).to eq('This is a test error')
    end
  end
end
