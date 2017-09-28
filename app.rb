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
    authentication_json = JSON.parse(auth_response.body)
    session[:token] = authentication_json['token']
    redirect '/home'
  end

  get '/home' do
    @token = session[:token]
    @new_recipient = session[:new_recipient]
    erb(:home)
  end

  get '/recipients/new' do
    erb(:'/recipients/new')
  end

  post '/recipients' do
    @token = session[:token]
    @coolpay = CoolPay.new
    new_recipient_response = @coolpay.add_recipient(params[:name], @token)
    new_recipient_json = JSON.parse(new_recipient_response.body)
    session[:new_recipient] = new_recipient_json['recipient']['name']
    redirect '/home'
  end

  get '/recipients' do
    @token = session[:token]
    @coolpay = CoolPay.new
    recipients_response = @coolpay.list_recipients(@token)
    recipients_json = JSON.parse(recipients_response.body)
    @recipients = recipients_json['recipients']
    erb(:'/recipients/show')
  end

  get '/payments/new' do
    erb(:'/payments/new')
  end
end
