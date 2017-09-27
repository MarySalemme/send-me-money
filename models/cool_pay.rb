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
# begin might not be necessary
    begin
      response = @rest_client_class.post 'https://coolpay.herokuapp.com/api/login', body, headers
    rescue RestClient::ExceptionWithResponse => exc
      response = exc.response
    end

    response
  end

  def add_recipient(name, token)
    body = req_recipient_body(name)
    headers = req_recipient_header(token)
    begin
      response = @rest_client_class.post 'https://coolpay.herokuapp.com/api/recipients', body, headers
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

  def req_header
    {
      :content_type => 'application/json'
    }
  end

  def req_recipient_body(name)
    {
      recipient: {
        name: name
      }
    }.to_json
  end

  def req_recipient_header(token)
    {
      :content_type => 'application/json',
      :authorization => "Bearer #{token}"
    }
  end
end
