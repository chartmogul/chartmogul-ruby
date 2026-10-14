# frozen_string_literal: true

module ApiRequestStubs
  def request_double
    req = double('request', headers: {})
    allow(req).to receive(:body=) { |value| @sent_body = value }
    req
  end

  def stub_api_request(method, path, response_body)
    connection = double('connection')
    allow(described_class).to receive(:connection).and_return(connection)
    allow(connection).to receive(method) do |request_path, &req_block|
      req_block.call(request_double)
      expect(request_path).to eq(path)
      double('response', body: response_body)
    end
  end

  def sent_body
    JSON.parse(@sent_body)
  end
end
