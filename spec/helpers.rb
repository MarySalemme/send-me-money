require 'json'

VALID_USERNAME = "valid_username"
VALID_KEY = "valid_key"
INVALID_USERNAME = "invalid_name"
INVALID_KEY = "invalid_key"
AUTH_TOKEN = "valid_auth"

def login_api_url
  'https://coolpay.herokuapp.com/api/login'
end

def recipient_api_url
  'https://coolpay.herokuapp.com/api/recipients'
end

def payment_api_url
  'https://coolpay.herokuapp.com/api/payments'
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

def req_recipient_body(name: 'John Doe')
  {
    recipient: {
      name: name
    }
  }.to_json
end

def req_recipient_header
  {
    :content_type => 'application/json',
    :authorization => "Bearer #{AUTH_TOKEN}"
  }
end

def req_payment_body(amount: '100', recipient_id: '123456')
  {
    payment: {
      amount: amount,
      currency: "GBP",
      recipient_id: recipient_id
    }
  }.to_json
end

def auth_response_body
  {
    "token" => AUTH_TOKEN
  }
end

def new_recipient_response_body
  {
    "recipient"=>{"name"=>"John Doe", "id"=>"cc3a4eef-c370-4a86-ad8e-f246dda4dfb6"}
  }
end

def recipient_list_response_body
  {
    "recipients"=>[{"name"=>"John Doe", "id"=>"123456"}]
  }
end

def payment_response_body
  {
    "payment": {
      "id": "123456",
      "amount": "100",
      "currency": "GBP",
      "recipient_id": "123456",
      "status": "processing"
    }
  }
end

def authenticate
  visit('/')
  click_button('Authenticate')
end

def add_recipient
  click_button('New Recipient')
  fill_in(:name, with: 'John Doe')
  click_button('Submit')
end
