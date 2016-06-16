require 'spec_helper'

describe ChartMogul::Import::Customer do
  let(:attrs) do
    {
      uuid: 'cus_adcd3-12345-123345',
      data_source_uuid: 'ds_123456',
      name: 'Test Customer',
      external_id: 'X1234',
      city: 'Berlin',
      state: 'BE',
      country: 'DE',
      zip: '10115'
    }
  end

  describe '#initialize' do
    subject { described_class.new(attrs) }

    it 'doesnt set the uuid attribute' do
      expect(subject.uuid).to be_nil
    end

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Customer')
    end

    it 'sets the data_source_uuid attribute' do
      expect(subject.data_source_uuid).to eq('ds_123456')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('X1234')
    end

    it 'sets the city attribute' do
      expect(subject.city).to eq('Berlin')
    end

    it 'sets the state attribute' do
      expect(subject.state).to eq('BE')
    end

    it 'sets the country attribute' do
      expect(subject.country).to eq('DE')
    end

    it 'sets the zip attribute' do
      expect(subject.zip).to eq('10115')
    end
  end

  describe '.new_from_json' do
    subject { described_class.new_from_json(attrs) }

    it 'sets the uuid attribute' do
      expect(subject.uuid).to eq('cus_adcd3-12345-123345')
    end

    it 'sets the data_source_uuid attribute' do
      expect(subject.data_source_uuid).to eq('ds_123456')
    end

    it 'sets the name attribute' do
      expect(subject.name).to eq('Test Customer')
    end

    it 'sets the external_id attribute' do
      expect(subject.external_id).to eq('X1234')
    end

    it 'sets the city attribute' do
      expect(subject.city).to eq('Berlin')
    end

    it 'sets the state attribute' do
      expect(subject.state).to eq('BE')
    end

    it 'sets the country attribute' do
      expect(subject.country).to eq('DE')
    end

    it 'sets the zip attribute' do
      expect(subject.zip).to eq('10115')
    end
  end

  describe 'API Interactions', vcr: true do
    it 'correctly interracts with the API', uses_api: true do
      ds = ChartMogul::Import::DataSource.create!(name: 'Customer Test Data Source')

      customer = ChartMogul::Import::Customer.create!(
        name: 'Test Customer',
        external_id: 'X1234',
        data_source_uuid: ds.uuid,
        email: 'test@example.com',
        city: 'Berlin',
        country: 'DE'
      )

      customers = ChartMogul::Import::Customer.all

      expect(customers.size).to eq(1)
      expect(customers[0].uuid).not_to be_nil
      expect(customers[0].name).to eq('Test Customer')
      expect(customers[0].external_id).to eq('X1234')
      expect(customers[0].data_source_uuid).to eq(ds.uuid)
      expect(customers[0].email).to eq('test@example.com')
      expect(customers[0].city).to eq('Berlin')
      expect(customers[0].country).to eq('DE')

      customer.destroy!

      customers = ChartMogul::Import::Customer.all

      expect(customers).to be_empty
    end

    it 'correctly handles a 422 response', uses_api: true do
      expect { ChartMogul::Import::Customer.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end
  end
end
