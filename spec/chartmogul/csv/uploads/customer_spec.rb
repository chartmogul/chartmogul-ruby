require 'spec_helper'

describe ChartMogul::CSV::Uploads::Customer, vcr: true do
  subject(:customers_csv_upload) { described_class.new(data_source_uuid, file_path, batch_name) }
  describe '#new' do
    let(:data_source_uuid) { 'ds_uuid' }
    let(:file_path) { 'path/to/file' }
    let(:batch_name) { 'customers_2020_09_01' }
    it 'creates an object with the correct attributes' do
      expect(customers_csv_upload).to have_attributes(
        data_source_uuid: data_source_uuid,
        filename: file_path,
        batch_name: batch_name
      )
    end
  end

  describe 'API Interactions', uses_api: true do
    context 'when we upload a csv file' do
      let(:data_source_uuid) { '4c48a4ca-c50e-11ea-9e88-23ec90c0c676' }
      let(:file_path) { 'spec/chartmogul/csv/uploads/customers.csv' }
      let(:batch_name) { 'Customers' }
      it 'sends csv file as multipart to data' do
        job = customers_csv_upload.send
        expect(job).to be_a(ChartMogul::CSV::Uploads::Job)
        expect(job).to have_attributes(
          original_name: 'customers.csv',
          data_type: 'customer',
          batch_name: 'Customers'
        )
      end
    end
  end
end
