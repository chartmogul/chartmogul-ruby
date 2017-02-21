require 'spec_helper'

describe ChartMogul::Customer do
  let(:attrs) do
    {
      uuid: 'cus_adcd3-12345-123345',
      data_source_uuid: 'ds_123456',
      name: 'Test Customer',
      external_id: 'X1234',
      city: 'Berlin',
      state: 'BE',
      country: 'DE',
      zip: '10115',
      lead_created_at: Time.utc(2016,10,1).to_s,
      free_trial_started_at: Time.utc(2016,10,2).to_s
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

    it 'sets the lead_created_at attribute' do
      expect(subject.lead_created_at).to eq(Time.utc(2016,10,1).to_s)
    end

    it 'sets the free_trial_started_at attribute' do
      expect(subject.free_trial_started_at).to eq(Time.utc(2016,10,2).to_s)
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

    it 'sets the lead_created_at attribute' do
      expect(subject.lead_created_at).to eq(Time.utc(2016,10,1))
    end

    it 'sets the free_trial_started_at attribute' do
      expect(subject.free_trial_started_at).to eq(Time.utc(2016,10,2))
    end
  end

  describe '.find_by_external_id', vcr: true do
    context 'when external_id is provided' do
      it 'returns matching user if exists', uses_api: true do
        result = ChartMogul::Customer.find_by_external_id('X1234')
        expect(result).not_to be_nil
        expect(result.external_id).to eq(attrs[:external_id])
      end

      it 'returns nil if customer does not exist', uses_api: true do
        result = ChartMogul::Customer.find_by_external_id('nope')
        expect(result).to be_nil
      end
    end
  end

  describe 'API Interactions', vcr: true do
    let(:lead_created_at) { Time.utc(2016,10,1,23,55) }
    let(:free_trial_started_at) { Time.utc(2016,10,12,11,12) }
    
    it 'correctly interracts with the API', uses_api: true do
      ds = ChartMogul::DataSource.create!(name: 'Customer Test Data Source')

      customer = ChartMogul::Customer.create!(
        name: 'Test Customer',
        external_id: 'X1234',
        data_source_uuid: ds.uuid,
        email: 'test@example.com',
        city: 'Berlin',
        country: 'DE',
        lead_created_at: lead_created_at.to_s,
        free_trial_started_at: free_trial_started_at.to_s
      )

      customers = ChartMogul::Customer.all

      expect(customers.size).to eq(1)
      expect(customers[0].uuid).not_to be_nil
      expect(customers[0].name).to eq('Test Customer')
      expect(customers[0].external_id).to eq('X1234')
      expect(customers[0].data_source_uuid).to eq(ds.uuid)
      expect(customers[0].email).to eq('test@example.com')
      expect(customers[0].city).to eq('Berlin')
      expect(customers[0].country).to eq('DE')
      expect(customers[0].lead_created_at).to eq(lead_created_at)
      expect(customers[0].free_trial_started_at).to eq(free_trial_started_at)

      customer.destroy!

      customers = ChartMogul::Customer.all

      expect(customers.entries).to be_empty
    end

    it 'correctly handles a 422 response', uses_api: true do
      expect { ChartMogul::Customer.create! }.to raise_error(ChartMogul::ResourceInvalidError)
    end
  end
end
