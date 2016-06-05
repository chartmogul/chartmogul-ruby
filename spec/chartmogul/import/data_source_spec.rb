require 'spec_helper'

describe ChartMogul::Import::DataSource do
  describe '#initialize' do
    subject { described_class.new(name: 'Test Data Source', uuid: 'abcd-1234') }

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Data Source')
    end

    it 'does not set the uuid' do
      expect(subject.uuid).to be_nil
    end
  end

  describe '#initialize_all' do
    let(:json_attrs) do
      {
        name: 'Test Data Source',
        uuid: 'abcd-1234',
        created_at: "2016-06-05T15:33:34.000Z",
        status: 'never_imported'
      }
    end

    subject { described_class.new_from_json(json_attrs) }

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Data Source')
    end

    it 'sets the UUID' do
      expect(subject.uuid).to eq('abcd-1234')
    end

    it 'sets created_at' do
      expect(subject.created_at).to eq(Time.utc(2016,06,05,15,33,34))
    end

    it 'sets the status' do
      expect(subject.status).to eq('never_imported')
    end
  end

  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      ds = ChartMogul::Import::DataSource.create!(name: 'Test Data Source')

      expect(ds.uuid).not_to be_nil
      expect(ds.name).to eq('Test Data Source')

      data_sources = ChartMogul::Import::DataSource.all

      expect(data_sources.size).to eq(1)
      expect(data_sources[0].uuid).to eq(ds.uuid)
      expect(data_sources[0].name).to eq(ds.name)
      expect(data_sources[0].created_at).to eq(ds.created_at)
      expect(data_sources[0].status).to eq(ds.status)

      data_sources[0].destroy!

      new_data_sources = ChartMogul::Import::DataSource.all
      expect(new_data_sources).to be_empty
    end

    it 'correctly raises errors on 422', uses_api: true do
      expect { ChartMogul::Import::DataSource.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end

    it 'correctly raises errors on 404', uses_api: true do
      ds = ChartMogul::Import::DataSource.new
      ds.send(:set_uuid, '1234-a-uuid-that-doesnt-exist')
      expect { ds.destroy! }.to raise_error(ChartMogul::NotFoundError)
    end
  end
end
