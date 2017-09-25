require 'sinatra/base'
require "sinatra/config_file"
require './models/cool_pay.rb'
require 'json'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  config_file './config.yml'
  API_USER = settings.coolpay_username
  API_KEY = settings.coolpay_apikey

  configure(:development) { set :session_secret, "something" }
  enable :sessions

  get '/' do
    erb(:index)
  end

  post '/home' do
    @coolpay = CoolPay.new
    auth_response = @coolpay.authenticate(API_USER, API_KEY)
    json = JSON.parse(auth_response.body)
    session[:token] = json['token']
    redirect '/home'
  end

  get '/home' do
    @token = session[:token]
    erb(:home)
  end
end
