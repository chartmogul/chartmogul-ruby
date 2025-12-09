# frozen_string_literal: true

require 'spec_helper'

describe ChartMogul::DataSource do
  describe '#initialize' do
    subject { described_class.new(name: 'Test Data Source', uuid: 'abcd-1234') }

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Data Source')
    end

    it 'does not set the uuid' do
      expect(subject.uuid).to be_nil
    end
  end

  describe '.new_from_json' do
    let(:json_attrs) do
      {
        name: 'Test Data Source',
        uuid: 'abcd-1234',
        created_at: '2016-06-05T15:33:34.000Z',
        status: 'never_imported'
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets all properties correctly' do
      expect(subject).to have_attributes(
        name: 'Test Data Source',
        uuid: 'abcd-1234',
        created_at: Time.utc(2016, 6, 5, 15, 33, 34),
        status: 'never_imported'
      )
    end
  end

  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      ds = ChartMogul::DataSource.create!(name: 'Test Data Source')

      expect(ds.uuid).not_to be_nil
      expect(ds.name).to eq('Test Data Source')

      data_sources = ChartMogul::DataSource.all(
        with_processing_status: true,
        with_auto_churn_subscription_setting: true,
        with_invoice_handling_setting: true,
      )

      expect(data_sources.size).to eq(1)
      data_source = data_sources[0]
      expect(data_source.uuid).to eq(ds.uuid)
      expect(data_source.name).to eq(ds.name)
      expect(data_source.created_at).to eq(ds.created_at)
      expect(data_source.status).to eq(ds.status)
      expect(data_source.processing_status).to be_a(ChartMogul::DataSourceSettings::ProcessingStatus)
      expect(data_source.processing_status.processed).to eq(12)
      expect(data_source.processing_status.failed).to eq(8)
      expect(data_source.processing_status.pending).to eq(37)
      expect(data_source.auto_churn_subscription_setting).to be_a(ChartMogul::DataSourceSettings::AutoChurnSubscriptionSetting)
      expect(data_source.auto_churn_subscription_setting.enabled).to eq(true)
      expect(data_source.auto_churn_subscription_setting.interval).to eq(30)
      expect(data_source.invoice_handling_setting).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSetting)
      expect(data_source.invoice_handling_setting.automatic).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSettings)
      expect(data_source.invoice_handling_setting.automatic.create_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.automatic.update_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_refunded).to eq(false)
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_voided).to eq(true)
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_written_off).to eq(true)
      expect(data_source.invoice_handling_setting.manual).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSettings)
      expect(data_source.invoice_handling_setting.manual.create_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.manual.update_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_refunded).to eq(false)
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_voided).to eq(true)
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_written_off).to eq(true)

      data_source = ChartMogul::DataSource.retrieve(ds.uuid,
        with_processing_status: true,
        with_auto_churn_subscription_setting: true,
        with_invoice_handling_setting: true,
      )
      expect(data_source.uuid).to eq(ds.uuid)
      expect(data_source.name).to eq(ds.name)
      expect(data_source.created_at).to eq(ds.created_at)
      expect(data_source.status).to eq(ds.status)
      expect(data_source.processing_status).to be_a(ChartMogul::DataSourceSettings::ProcessingStatus)
      expect(data_source.processing_status.processed).to eq(12)
      expect(data_source.processing_status.failed).to eq(8)
      expect(data_source.processing_status.pending).to eq(37)
      expect(data_source.auto_churn_subscription_setting).to be_a(ChartMogul::DataSourceSettings::AutoChurnSubscriptionSetting)
      expect(data_source.auto_churn_subscription_setting.enabled).to eq(true)
      expect(data_source.auto_churn_subscription_setting.interval).to eq(30)
      expect(data_source.invoice_handling_setting).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSetting)
      expect(data_source.invoice_handling_setting.automatic).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSettings)
      expect(data_source.invoice_handling_setting.automatic.create_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.automatic.update_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_refunded).to eq(false)
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_voided).to eq(true)
      expect(data_source.invoice_handling_setting.automatic.prevent_subscription_for_invoice_written_off).to eq(true)
      expect(data_source.invoice_handling_setting.manual).to be_a(ChartMogul::DataSourceSettings::InvoiceHandlingSettings)
      expect(data_source.invoice_handling_setting.manual.create_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.manual.update_subscription_when_invoice_is).to eq('open')
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_refunded).to eq(false)
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_voided).to eq(true)
      expect(data_source.invoice_handling_setting.manual.prevent_subscription_for_invoice_written_off).to eq(true)

      data_sources[0].destroy!

      new_data_sources = ChartMogul::DataSource.all
      expect(new_data_sources).to be_empty
    end

    it 'correctly raises errors on 422', uses_api: true do
      expect { ChartMogul::DataSource.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'correctly raises errors on 404', uses_api: true do
      ds = ChartMogul::DataSource.new
      ds.send(:set_uuid, '1234-a-uuid-that-doesnt-exist')
      expect { ds.destroy! }.to raise_error(ChartMogul::NotFoundError)
    end

    it 'retrieves existing data source matching uuid', uses_api: true do
      ds = ChartMogul::DataSource.create!(name: 'TestDS')
      ds.send(:set_uuid, 'ds_5ee8bf93-b0b4-4722-8a17-6b624a3af072')

      data_source = described_class.retrieve('ds_5ee8bf93-b0b4-4722-8a17-6b624a3af072')
      expect(data_source).to be
    end
  end
end
