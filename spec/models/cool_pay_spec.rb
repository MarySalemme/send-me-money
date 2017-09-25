require 'spec_helper'

describe CoolPay do

  let(:rest_client) { double "RestClient" }
  let(:authenticated_response) { double "RestClient::Response", code: 200 }
  let(:fail_auth_response) { double "RestClent::Response", code: 404 }
  let(:fail_auth_exception) { double "RestClient::ExceptionWithResponse" }
  subject(:coolpay) { described_class.new(rest_client) }

  before :each do
    allow(authenticated_response)
      .to receive(:body) { auth_response_body }

    allow(fail_auth_exception)
      .to receive(:response) { fail_auth_response }

    allow(rest_client)
      .to receive(:post)
      .with(login_api_url, req_body, req_header) { authenticated_response }

    allow(rest_client)
      .to receive(:post)
      .with(login_api_url, req_body(username: INVALID_USERNAME, apikey: INVALID_KEY), req_header)
      .and_raise( fail_auth_exception )
  end

  describe '#authenticate' do
    it 'returns the authenticated response if successful' do
      response = coolpay.authenticate(VALID_USERNAME, VALID_KEY)
      result = response.body["token"]
      expect(result).to eq AUTH_TOKEN
    end
  end
end
