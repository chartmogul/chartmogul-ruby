# frozen_string_literal: true

# RSpec.shared_examples 'accepts query param' do |method_name, path, query_params, response_body, *args|
#   it "accepts #{query_params.keys.join(', ')} query parameter(s)", uses_api: false do
#     allow(described_class).to receive(:connection).and_return(double('connection'))
#     expect(described_class.connection).to receive(method_name).with(path) do |&block|
#       req = double('request')
#       headers = {}
#       allow(req).to receive(:headers).and_return(headers)
#       allow(req).to receive(:[]=) { |k, v| headers[k] = v }
#       expect(req).to receive(:params=).with(hash_including(query_params))
#       block.call(req)
#       double('response', body: response_body)
#     end

#     described_class.public_send(*args)
#   end
# end

RSpec.shared_examples 'retrieve with query params' do |resource_id, query_params, response_body_mock|
  it "accepts #{query_params.keys.join(', ')} query parameter(s)", uses_api: false do
    # Evaluate lambdas/procs for dynamic values - this happens inside the it block where let bindings are available
    # id = resource_id.respond_to?(:call) ? instance_exec(&resource_id) : resource_id
    # body = response_body_mock.respond_to?(:call) ? instance_exec(&response_body_mock) : response_body_mock

    path = "#{described_class.resource_path.path}/#{resource_id}"
    allow(described_class).to receive(:connection).and_return(double('connection'))
    expect(described_class.connection).to receive(:get).with(path) do |&block|
      req = double('request')
      headers = {}
      allow(req).to receive(:headers).and_return(headers)
      allow(req).to receive(:[]=) { |k, v| headers[k] = v }
      expect(req).to receive(:params=).with(hash_including(query_params))
      block.call(req)
      double('response', body: response_body_mock)
    end

    described_class.retrieve(resource_id, query_params)
  end
end
