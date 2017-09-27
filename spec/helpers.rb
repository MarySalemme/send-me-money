require 'json'

VALID_USERNAME = "valid_username"
VALID_KEY = "valid_key"
INVALID_USERNAME = "invalid_name"
INVALID_KEY = "invalid_key"
AUTH_TOKEN = "valid_auth"

def login_api_url
  'https://coolpay.herokuapp.com/api/login'
end

def req_body(username: VALID_USERNAME, apikey: VALID_KEY)
  {
    username: username,
    apikey: apikey
  }.to_json
end

def req_header(auth: nil)
  return { :content_type => 'application/json' } unless auth
  return {
    :content_type => 'application/json',
    :authorization => auth
  }
end

def auth_response_body
  {
    "token" => AUTH_TOKEN
  }
end

def authenticate
  visit('/')
  click_button('Authenticate')
end
