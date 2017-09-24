require 'rest_client'
require 'json'

class CoolPay

  attr_reader :token

  def initialize
    @token = nil
  end

  def authenticate(username, key)
    body = req_body(username, key)

    headers = req_header

    response = RestClient.post 'https://coolpay.herokuapp.com/api/login', body, headers
    json = JSON.parse(response.body)
    @token = json['token']
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

end
