require 'rest_client'
require 'json'

class CoolPay

  def initialize(rest_client_class = RestClient)
    @rest_client_class = rest_client_class
    @token = nil
  end

  def authenticate(username, key)
    body = req_body(username, key)
    headers = req_header
    begin
      response = @rest_client_class.post 'https://coolpay.herokuapp.com/api/login', body, headers
    rescue RestClient::ExceptionWithResponse => exc
      response = exc.response
    end
    response
  end

  def add_recipient(name, token)
    body = req_recipient_body(name)
    headers = req_header(token)
    begin
      response = @rest_client_class.post 'https://coolpay.herokuapp.com/api/recipients', body, headers
    rescue RestClient::ExceptionWithResponse => exc
      response = exc.response
    end
    response
  end

  def list_recipients(token)
    headers = req_header(token)
    begin
      response = @rest_client_class.get 'https://coolpay.herokuapp.com/api/recipients', headers
    rescue RestClient::ExceptionWithResponse => exc
      response = exc.response
    end
    response
  end

  def make_payment(amount, recipient_id, token)
    body = req_payment_body(amount, recipient_id)
    headers = req_header(token)
    begin
      response = @rest_client_class.post 'https://coolpay.herokuapp.com/api/payments', body, headers
    rescue RestClient::ExceptionWithResponse => exc
      response = exc.response
    end
    response
  end

  private

  def req_body(username, key)
    {
      username: username,
      apikey: key
    }.to_json
  end

  def req_header(auth_token = nil)
    header = {
      :content_type => 'application/json'
    }
    header[:authorization] = "Bearer #{auth_token}" if auth_token
    header
  end

  def req_recipient_body(name)
    {
      recipient: {
        name: name
      }
    }.to_json
  end

  def req_payment_body(amount, recipient_id)
    {
      payment: {
        amount: amount,
        currency: "GBP",
        recipient_id: recipient_id
      }
    }.to_json
  end
end
