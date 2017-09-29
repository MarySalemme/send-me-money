require 'spec_helper'

describe CoolPay do
  let(:rest_client) { double 'RestClient' }
  let(:authenticated_response) { double 'RestClient::Response', code: 200 }
  let(:recipient_response) { double 'RestClient::Response', code: 200 }
  let(:recipient_list_response) { double 'RestClent::Response', code: 200 }
  let(:payment_response) { double 'RestClent::Response', code: 200 }
  let(:fail_auth_response) { double 'RestClent::Response', code: 404 }
  let(:fail_auth_exception) { double 'RestClient::ExceptionWithResponse' }
  subject(:coolpay) { described_class.new(rest_client) }

  before :each do
    allow(authenticated_response)
      .to receive(:body) { auth_response_body }

    allow(recipient_response)
      .to receive(:body) { new_recipient_response_body }

    allow(recipient_list_response)
      .to receive(:body) { recipient_list_response_body }

    allow(payment_response)
      .to receive(:body) { payment_response_body }

    allow(fail_auth_exception)
      .to receive(:response) { fail_auth_response }

    allow(rest_client)
      .to receive(:post)
      .with(login_api_url, req_body, req_header) { authenticated_response }

    allow(rest_client)
      .to receive(:post)
      .with(recipient_api_url, req_recipient_body, req_recipient_header) { recipient_response }

    allow(rest_client)
      .to receive(:get)
      .with(recipient_api_url, req_recipient_header) { recipient_list_response }

    allow(rest_client)
      .to receive(:post)
      .with(payment_api_url, req_payment_body, req_recipient_header) { payment_response }
  end

  describe '#authenticate' do
    it 'returns the authenticated response if successful' do
      response = coolpay.authenticate(VALID_USERNAME, VALID_KEY)
      result = response.body['token']
      expect(result).to eq AUTH_TOKEN
    end
  end

  describe '#add_recipient' do
    it 'returns the added recipient' do
      response = coolpay.add_recipient('John Doe', AUTH_TOKEN)
      result = response.body['recipient']['name']
      expect(result).to eq 'John Doe'
    end
  end

  describe '#list_recipients' do
    it 'returns a list with all recipients' do
      coolpay.add_recipient('John Doe', AUTH_TOKEN)
      response = coolpay.list_recipients(AUTH_TOKEN)
      result = response.body['recipients']
      expect(result).to eq [{ 'name' => 'John Doe', 'id' => '123456' }]
    end
  end

  describe '#make_payment' do
    it 'returns the payment response if successful' do
      response = coolpay.make_payment('100', '123456', AUTH_TOKEN)
      result = response.body[:payment][:status]
      expect(result).to eq 'processing'
    end
  end
end
