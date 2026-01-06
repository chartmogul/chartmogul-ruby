# frozen_string_literal: true

RSpec.shared_examples 'retrieve with query params' do |resource_id, query_params, response_body_mock, assertions = nil|
  it "accepts #{query_params.keys.join(', ')} query parameter(s)", uses_api: false do
    path = "#{described_class.resource_path.path}/#{resource_id}"
    allow(described_class).to receive(:connection).and_return(double('connection'))
    expect(described_class.connection).to receive(:get).with(path) do |&req_block|
      req = double('request')
      headers = {}
      allow(req).to receive(:headers).and_return(headers)
      allow(req).to receive(:[]=) { |k, v| headers[k] = v }
      expect(req).to receive(:params=).with(hash_including(query_params))

      req_block.call(req)
      double('response', body: response_body_mock)
    end

    retrieved_resource = described_class.retrieve(resource_id, query_params)
    instance_exec(retrieved_resource, &assertions) if assertions
  end
end
