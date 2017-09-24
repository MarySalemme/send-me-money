require 'sinatra/base'
require "sinatra/config_file"
require './models/cool_pay.rb'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  config_file './config.yml'
  API_USER = settings.coolpay_username
  API_KEY = settings.coolpay_apikey

  get '/' do
    erb(:index)
  end

  post '/home' do
    @coolpay = CoolPay.new
    @coolpay.authenticate(API_USER, API_KEY)
    @token = @coolpay.token
    erb(:home)
  end
end
