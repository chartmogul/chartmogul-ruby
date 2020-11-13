# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::Batch::Import do
  subject(:batch_importer) do
    ChartMogul::Batch::Import.new(
      data_source_uuid: data_source_uuid,
      invoices: invoices,
      customers: customers,
      plans: plans,
      transactions: transactions,
      line_items: line_items
    )
  end

  let(:invoices) { [] }
  let(:plans) { [] }
  let(:customers) { [] }
  let(:transactions) { [] }
  let(:line_items) { [] }
  let(:cancellations) { [] }

  describe '#new' do
    let(:data_source_uuid) { 'data_source_uuid' }
    let(:invoice_1) do
      ChartMogul::CSV::Invoice.new(
        external_id: 'invoice_1', customer_external_id: 'customer_1'
      )
    end
    let(:invoice_2) do
      ChartMogul::CSV::Invoice.new(
        external_id: 'invoice_2', customer_external_id: 'customer_1'
      )
    end
    let(:invoice_3) do
      ChartMogul::CSV::Invoice.new(
        external_id: 'invoice_3', customer_external_id: 'customer_1'
      )
    end
    let(:plan_1) { ChartMogul::CSV::Plan.new(external_id: 'plan_1', name: 'Plan 1') }
    let(:plan_2) { ChartMogul::CSV::Plan.new(external_id: 'plan_2', name: 'Plan 2') }
    let(:customer_1) { ChartMogul::CSV::Customer.new(external_id: 'customer_1') }

    context 'test import' do
      let(:invoices) { [invoice_1, invoice_2, invoice_3] }
      let(:plans) { [plan_1, plan_2] }
      let(:customers) { [customer_1] }

      it 'has correct properties' do
        expect(batch_importer.invoices.count).to be(3)
        expect(batch_importer.plans).to eq([plan_1, plan_2])
        expect(batch_importer.customers).to eq([customer_1])
      end
    end
  end
end
